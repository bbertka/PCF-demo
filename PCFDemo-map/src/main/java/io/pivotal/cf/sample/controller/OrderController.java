package io.pivotal.cf.sample.controller;

import io.pivotal.cf.sample.HeatMap;
import io.pivotal.cf.sample.Order;
import io.pivotal.cf.sample.OrderConsumer;
import io.pivotal.cf.sample.RabbitClient;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.List;

import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import java.io.IOException;
import java.io.StringWriter;
import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;

import javax.servlet.ServletContext;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.pivotal.cf.sample.CFClient;

import org.cloudfoundry.client.lib.domain.CloudApplication;

/**
 * Handles requests for the application home page.
 */
@Controller
public class OrderController {
	
	@Autowired
	ServletContext context;
	
	private static Map<String,Queue<Order>> stateOrdersMap = new HashMap<String, Queue<Order>>();
	private static RabbitClient client ;
	private CFClient pwsclient = new CFClient("email","password", "https://api-endpoint");


	boolean generatingData = false;
	
	static Logger logger = Logger.getLogger(OrderController.class);

	Thread threadConsumer = new Thread (new OrderConsumer());
	
	
    public OrderController(){
  
    	client = RabbitClient.getInstance();

    	for (int i=0; i<HeatMap.states.length; i++){
    		stateOrdersMap.put(HeatMap.states[i], new ArrayBlockingQueue<Order>(10));
    	}

    	threadConsumer.start();
    }
	
	private int getOrderSum(String state){
		
		int sum = 0;
		Queue<Order> q  = stateOrdersMap.get(state);
		Iterator<Order> it = q.iterator();
		while (it.hasNext()){
			sum += it.next().getAmount();
		}
		
		return sum;
	}
    

	
	public static synchronized void registerOrder(Order order){
		Queue<Order> orderQueue = stateOrdersMap.get(order.getState());
		if (!orderQueue.offer(order)){
			orderQueue.remove();
			orderQueue.add(order);
		}				
	}
    
	@RequestMapping(value = "/")
	public String home(Model model) throws JsonGenerationException, JsonMappingException, IOException {
		model.addAttribute("rabbitURI", client.getRabbitURI());	
		//model.addAttribute("producerApps", this.getProducers() );
        return "WEB-INF/views/pcfdemo.jsp";
    }

    @RequestMapping(value="/getData")
    public @ResponseBody double getData(@RequestParam("state") String state){
    	if (!stateOrdersMap.containsKey(state)) return 0;
    	Queue<Order> q = stateOrdersMap.get(state);
    	if (q.size()==0) return 0;
    	Order[] orders = q.toArray(new Order[]{});
    	return orders[orders.length-1].getAmount();

    }    	
    

    @RequestMapping(value="/getCompleteData")
    public @ResponseBody Map getCompleteData(){
    	return stateOrdersMap;

    }    

    
    @RequestMapping(value="/killApp")
    public @ResponseBody String kill(){
		logger.warn("Killing application instance");
		System.exit(-1);    	
    	return "Killed";

    }       
    
    @RequestMapping(value="/getHeatMap")
    public @ResponseBody HeatMap getHistograms(){
    	HeatMap heatMap = new HeatMap();
    	for (int i=0; i<HeatMap.states.length; i++){
    		heatMap.addOrderSum(HeatMap.states[i], getOrderSum(HeatMap.states[i]));
    	}    	

    	heatMap.assignColors();
    	return heatMap;
    }
    

    @RequestMapping(value="/getEnvironment")
    public @ResponseBody String getEnvironment() throws IOException {
    	Map<String, String> env = System.getenv();
    	String mapAsJson = new ObjectMapper().writeValueAsString(env);
    	return mapAsJson;
    }
    

    
    /*
     * These functions get the list of producer apps from the CF Java client
     */
	@RequestMapping(value="/getApplications")
	public @ResponseBody String getApplications() throws JsonGenerationException, JsonMappingException, IOException {
		String mapAsJson = new ObjectMapper().writeValueAsString(getProducers());
		return mapAsJson;
	}
	
	public ArrayList<CloudApplication> getProducers() throws JsonGenerationException, JsonMappingException, IOException {
		List<CloudApplication> applications = this.pwsclient.getApplications();
		ArrayList<CloudApplication> producers = new ArrayList<CloudApplication>(applications.size());
        for ( CloudApplication app : applications ) {
        	
        	//bbertka: This should use some ENV prefix
        	if(app.getName().startsWith("pcfdemo-producer") ){
        		producers.add(app);
        	}        			
        }
        return producers;
	}

}
