package io.pivotal.cf.sample;


import org.apache.log4j.Logger;
import org.cloudfoundry.client.lib.CloudCredentials;
import org.cloudfoundry.client.lib.CloudFoundryClient;
import org.cloudfoundry.client.lib.domain.CloudApplication;
import org.cloudfoundry.client.lib.domain.CloudService;
import org.cloudfoundry.client.lib.domain.CloudSpace;
import org.springframework.security.oauth2.common.OAuth2AccessToken;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

import java.util.List;

public class CFClient {

    static Logger logger = Logger.getLogger(CFClient.class);
	
    private CloudCredentials credentials;
    private CloudFoundryClient client;
    private OAuth2AccessToken token;
    
    public CFClient(String user, String password, String target){
        logger.info("Logging into " + target + " " + user + "/*****");
    	this.credentials = new CloudCredentials(user, password);
    	this.client = new CloudFoundryClient(credentials, getTargetURL(target), true);
        this.token = this.client.login();
    }

    public OAuth2AccessToken getToken() {
        return this.token;
    }

    public void reauthenticate() {
        this.token = this.client.login();
    }
    
    private static URL getTargetURL(String target) {
        try {
            return URI.create(target).toURL();
        } catch (MalformedURLException e) {
            throw new RuntimeException("The target URL is not valid: " + e.getMessage());
        }
    }
    
    public List<CloudApplication> getApplications(){
    	return this.client.getApplications();
    }
    
}