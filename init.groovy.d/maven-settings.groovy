import jenkins.model.*
import org.jenkinsci.plugins.configfiles.maven.*
import org.jenkinsci.plugins.configfiles.maven.security.*
 
def instance = Jenkins.getInstance()

Thread.start {
    sleep 10000
    def mirrorUrl = System.getenv("NEXUS_REPO")
    if (mirrorUrl) {
        println("--> Setting global maven settings")
        def store = instance.getExtensionList('org.jenkinsci.plugins.configfiles.GlobalConfigFiles')[0]
        def configId =  'global-maven-settings'
        def configName = 'global-maven-settings'
        def configComment = 'Maven Mirror Settings'
        def configContent  = """<?xml version="1.0" encoding="UTF-8"?>
<settings xmlns="http://maven.apache.org/SETTINGS/1.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.1.0 http://maven.apache.org/xsd/settings-1.1.0.xsd">
  <mirrors>
    <mirror>
      <id>nexus</id>
      <name>Local Maven Repository Manager</name>
      <url>${mirrorUrl}</url>
      <mirrorOf>*</mirrorOf>
    </mirror>
  </mirrors>
  <servers>
    <server>
      <id>deployment</id>
      <username>deployment</username>
      <password>deployment123</password>
    </server>
  </servers>
</settings>
"""
        def globalConfig = new GlobalMavenSettingsConfig(configId, configName, configComment, configContent, false, null)
        store.save(globalConfig)
    }
}
