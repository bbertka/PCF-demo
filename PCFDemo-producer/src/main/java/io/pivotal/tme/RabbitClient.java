/**
 * 
 */
package io.pivotal.tme;

import java.io.IOException;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;

import org.springframework.cloud.Cloud;
import org.springframework.cloud.CloudException;
import org.springframework.cloud.CloudFactory;
import org.springframework.cloud.service.ServiceInfo;
import org.springframework.cloud.service.common.AmqpServiceInfo;

import com.rabbitmq.client.Channel;
import com.rabbitmq.client.Connection;
import com.rabbitmq.client.ConnectionFactory;

/**
 * @author bbertka
 *
 */
public class RabbitClient {

	static Logger logger = Logger.getLogger(RabbitClient.class);
	private static RabbitClient instance;
	
	private static final String QUEUE_NAME="ORDERS_QUEUE";

	private ConnectionFactory factory;
	private Connection senderConn;
	private String rabbitURI;
	
	private RabbitClient(){
		
    	try{
    		Cloud cloud = new CloudFactory().getCloud();
	    	Iterator<ServiceInfo> services = cloud.getServiceInfos().iterator();
	    	while (services.hasNext()){
	    		ServiceInfo svc = services.next();
	    		if (svc instanceof AmqpServiceInfo){
	    			AmqpServiceInfo rabbitSvc = ((AmqpServiceInfo)svc);	    			
	    			rabbitURI=rabbitSvc.getUri();
	    			
	    			try{
	    				factory = new ConnectionFactory();
	    				factory.setUri(rabbitURI);
	    				senderConn = factory.newConnection();
	    				factory.newConnection();
	    			}
	    			catch(Exception e){
	    				throw new RuntimeException("Exception connecting to RabbitMQ",e);
	    			}
	    			
	    		}
	    	}
    	}
    	catch(CloudException ce){
    		// means its not being deployed on Cloud
    		logger.warn(ce.getMessage());
    	}
		
		
	}
	
	public static synchronized RabbitClient getInstance(){
		if (instance==null){
			instance = new RabbitClient(); 
		}
		return instance;
	}
	
	public synchronized void post(JSONObject order) throws IOException{
		if (senderConn==null || !senderConn.isOpen()){
			senderConn = factory.newConnection();
		}
		Channel channel = senderConn.createChannel();
		channel.queueDeclare(QUEUE_NAME, false, false, false, null);
	    channel.basicPublish("", QUEUE_NAME, null, order.toJSONString().getBytes());
	    channel.close();		
	}
	
}