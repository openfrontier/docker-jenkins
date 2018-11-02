import org.csanchez.jenkins.plugins.kubernetes.*
import jenkins.model.*

def instance = Jenkins.getInstance()

Thread.start {
    sleep 10000

    println("--> Configuring kubernetes plugin")
 
    cloud_exist = false
    if (instance.clouds) {
        instance.clouds.each {
           if (it.getDisplayName() == 'kubernetes') {
               println("Found existing cloud: ${it.getDisplayName()}")
               cloud_exist = true
           }
        }
    }
    if (!cloud_exist) {
        kc = new KubernetesCloud('kubernetes')
        kc.setSkipTlsVerify(true)
        kc.setContainerCapStr('5')
        jenkinsUrl = System.getenv("JENKINS_URL")
        jenkinsUrl && kc.setJenkinsUrl(jenkinsUrl)
        println "Adding k8s cloud: ${kc.getDisplayName()}"
        instance.clouds.add(kc)
    }
    instance.save()
}
