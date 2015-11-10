package io.pivotal.cf.sample;


import org.cloudfoundry.client.lib.CloudCredentials;
import org.cloudfoundry.client.lib.CloudFoundryClient;
import org.cloudfoundry.client.lib.domain.CloudApplication;
import org.cloudfoundry.client.lib.domain.CloudService;
import org.cloudfoundry.client.lib.domain.CloudSpace;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URL;

import java.util.List;

public class CFClient {
	
    private CloudCredentials credentials;
    private CloudFoundryClient client;
    
    public CFClient(String user, String password, String target){
    	this.credentials = new CloudCredentials(user, password);
    	this.client = new CloudFoundryClient(credentials, getTargetURL(target));
        this.client.login();
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