package io.pivotal.cf.sample.controller;

import io.pivotal.cf.sample.HeatMap;
import io.pivotal.cf.sample.Order;
import io.pivotal.cf.sample.OrderConsumer;
import io.pivotal.cf.sample.RabbitClient;

import java.util.*;


import org.apache.log4j.Logger;
import org.codehaus.jackson.JsonGenerationException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;

import java.io.IOException;
import java.util.concurrent.ArrayBlockingQueue;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.common.OAuth2AccessToken;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import io.pivotal.cf.sample.CFClient;

import org.springframework.web.client.RestTemplate;

/**
 * Handles requests for the application home page.
 */
@Controller
public class OrderController {

	private static Map<String,Queue<Order>> stateOrdersMap = new HashMap<String, Queue<Order>>();
	private static RabbitClient client;
	private CFClient _cf;
	private String _username;
	private String _password;
	private String _endpoint;

	static Logger logger = Logger.getLogger(OrderController.class);

	Thread threadConsumer = new Thread (new OrderConsumer());


    public OrderController() {
		//Create CF client
		_username = System.getenv("CF_USERNAME");
		_password = System.getenv("CF_PASSWORD");
		_endpoint = System.getenv("CF_ENDPOINT");
		_cf = new CFClient(_username, _password, "https://" + _endpoint);


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

	@RequestMapping(value="/clear")
	public @ResponseBody boolean clear(){
		for(Map.Entry<String, Queue<Order>> state : stateOrdersMap.entrySet()) {
			state.getValue().clear();
		}
		return true;
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
     * Returns current list of apps, but we can change
     */
	@RequestMapping(value="/getBackends")
	public @ResponseBody List<?> getBackends() throws JSONException, IOException {
		return getProducers(true);
	}

    /*
     * These functions get the list of producer apps from the CF Java client
     */
	@RequestMapping(value="/getApplications")
	public @ResponseBody List<?> getApplications() throws JSONException, IOException {
		//String mapAsJson = new ObjectMapper().writeValueAsString(getProducers(true));
		//return mapAsJson;
		return getProducers(true);
	}
	
	private List<?> getProducers(boolean reauthenticate) throws JSONException, IOException {
		//Need to use REST API directly so we can filter appropriately
		OAuth2AccessToken token = _cf.getToken();
		logger.info("Token: " + token.getValue());

		//pull a few variables about current CF env
		String vcap_app = System.getenv("VCAP_APPLICATION");
		logger.info("vcap: " + vcap_app);
		JSONObject vcap = new JSONObject(vcap_app);
		String space_guid = vcap.getString("space_id");
		String app_name = vcap.getString("application_name");

		RestTemplate template = new RestTemplate();
		HttpHeaders auth = new HttpHeaders();
		auth.set("Authorization","Bearer "+ token.getValue());
		HttpEntity<String> entity = new HttpEntity<String>(auth);

		try {
			ResponseEntity<Map> response = template.exchange(
					"http://"+this._endpoint+"/v2/apps?q=space_guid:" + space_guid,
					HttpMethod.GET,
					entity,
					Map.class);
			logger.info("response: " + response);
			logger.info("response map: " + response.getBody());
			List<?> resources = (List<?>) response.getBody().get("resources");
			logger.info("resources: " + resources);

			//remove the demo map
			List<Object> result = new ArrayList<Object>();
			for(Object obj : resources) {
				Map<String, Map<String,String>> app = (Map<String, Map<String,String>>) obj;
				String name = app.get("entity").get("name");
				logger.info("App: " + name);
				if(name.equalsIgnoreCase(app_name)) continue;
				result.add(obj);

			}

			return result;
		} catch(Exception ex) {
			if(reauthenticate) {
				return getProducers(false);
			}
			ex.printStackTrace();
		}
		return new ArrayList<Object>();
	}


}
