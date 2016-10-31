import hudson.model.*;
import jenkins.model.*;
import hudson.security.*;
import jenkins.security.plugins.ldap.*;
import hudson.util.Secret;
import com.cloudbees.plugins.credentials.SystemCredentialsProvider;
import com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl;
import com.cloudbees.plugins.credentials.CredentialsScope;

def env = System.getenv()

// Variables
def ldap_server = env['LDAP_SERVER']
def ldap_rootDN = env['LDAP_ROOTDN']
def configXmlFile = "/var/jenkins_home/config.xml"

// Constants
def instance = Jenkins.getInstance()

Thread.start {
    sleep 10000

    if(ldap_server && ldap_rootDN) {
        init_ldap_parameter = true
        def configXmlString = new File(configXmlFile).getText('UTF-8')
        def rootNode = new XmlSlurper().parseText(configXmlString)
        rootNode.securityRealm.each {
            if(it.@class == "hudson.security.LDAPSecurityRealm") {
                init_ldap_parameter = false
            }
        }
        if(init_ldap_parameter) {
            def ldap_userSearchBase = env['LDAP_USER_SEARCH_BASE']
            def ldap_userSearch = env['LDAP_USER_SEARCH']
            def ldap_groupSearchBase = env['LDAP_GROUP_SEARCH_BASE']
            def ldap_groupSearchFilter = env['LDAP_GROUP_SEARCH_FILTER']
            def ldap_groupMembershipFilter = env['LDAP_GROUP_MEMBERSHIP_FILTER']
            def ldap_managerDN = env['LDAP_MANAGER_DN']
            def ldap_managerPassword = env['LDAP_MANAGER_PASSWORD']
            def ldap_inhibitInferRootDN = env['LDAP_INHIBIT_INFER_ROOTDN'].toBoolean()
            def ldap_disableMailAddressResolver = env['LDAP_DISABLE_MAIL_ADDRESS_RESOLVER'].toBoolean()
            def ldap_displayNameAttributeName = env['LDAP_DISPLAY_NAME_ATTRIBUTE_NAME']
            def ldap_mailAddressAttributeName = env['LDAP_MAIL_ADDRESS_ATTRIBUTE_NAME']

            // Add Global credentials for LDAP
            println "--> Registering LDAP Credentials"
            def system_credentials_provider = SystemCredentialsProvider.getInstance()

            def credential_description = "LDAP Admin"

            ldap_credentials_exist = false
            system_credentials_provider.getCredentials().each {
                credentials = (com.cloudbees.plugins.credentials.Credentials) it
                if ( credentials.getDescription() == credential_description) {
                    ldap_credentials_exist = true
                    println("Found existing credentials: " + credential_description)
                }
            }

            if(!ldap_credentials_exist) {
                def credential_scope = CredentialsScope.GLOBAL
                def credential_id = "ldap-admin"
                def credential_username = ldap_managerDN
                def credential_password = ldap_managerPassword

                def credential_domain = com.cloudbees.plugins.credentials.domains.Domain.global()
                def credential_creds = new UsernamePasswordCredentialsImpl(credential_scope,credential_id,credential_description,credential_username,credential_password)

                system_credentials_provider.addCredentials(credential_domain,credential_creds)
            }

            // LDAP
            println "--> Configuring LDAP"

            def ldapRealm = new LDAPSecurityRealm(
                ldap_server, //String server
                ldap_rootDN, //String rootDN
                ldap_userSearchBase, //String userSearchBase
                ldap_userSearch, //String userSearch
                ldap_groupSearchBase, //String groupSearchBase
                ldap_groupSearchFilter, //String groupSearchFilter
                new FromGroupSearchLDAPGroupMembershipStrategy(ldap_groupMembershipFilter), //LDAPGroupMembershipStrategy groupMembershipStrategy
                ldap_managerDN, //String managerDN
                Secret.fromString(ldap_managerPassword), //Secret managerPasswordSecret
                ldap_inhibitInferRootDN, //boolean inhibitInferRootDN
                ldap_disableMailAddressResolver, //boolean disableMailAddressResolver
                null, //CacheConfiguration cache
                null, //EnvironmentProperty[] environmentProperties
                ldap_displayNameAttributeName, //String displayNameAttributeName
                ldap_mailAddressAttributeName, //String mailAddressAttributeName
                IdStrategy.CASE_INSENSITIVE, //IdStrategy userIdStrategy
                IdStrategy.CASE_INSENSITIVE //IdStrategy groupIdStrategy >> defaults
            )

           instance.setSecurityRealm(ldapRealm)

            // If no authorisation strategy is in place, default to "Authenticated users can do anything"
            def authStrategy = Hudson.instance.getAuthorizationStrategy()

            if (authStrategy instanceof AuthorizationStrategy.Unsecured) {
                println "Defaulting to 'Authenticated users can do anything' rather than 'unsecure'."
                instance.setAuthorizationStrategy(new FullControlOnceLoggedInAuthorizationStrategy())
            }

            // Save the state
            instance.save()
        }  
    }
}
