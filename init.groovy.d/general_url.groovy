import hudson.model.*;
import jenkins.model.*;

// Variables
def env = System.getenv()
def root_Url = env['ROOT_URL']

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    println "--> Configuring General URL Settings"

    if(root_Url) {
        // Base URL
        println "--> Setting Base URL"
        jlc = JenkinsLocationConfiguration.get()
        jlc.setUrl(root_Url)
        jlc.save()
    }
}
