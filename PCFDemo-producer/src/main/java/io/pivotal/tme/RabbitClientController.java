/**
 * 
 */
package io.pivotal.tme;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

import org.apache.log4j.Logger;
import org.json.simple.JSONObject;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Controller;

/**
 * @author bbertka
 *
 */
@Controller
public class RabbitClientController implements CommandLineRunner {

	static Logger logger = Logger.getLogger(RabbitClient.class);
	
	private final String[] all_states = { "ca", "ny", "ma", "tx", "il", "wa", "fl", "pa", "va", "nj", "or", "oh", "mi", "co", "md", "nc", "ga",
       		"mn", "az", "in", "wi", "mo", "tn", "ct", "dc", "ut", "nm", "ks", "ky", "ok", "sc", "la", "nv", "ia",
       		"nh", "al", "ar", "me", "hi", "ne", "id", "ri", "vt", "mt", "wv", "de", "ak", "ms", "wy", "sd", "nd",
       		"pr", "as"};

	@Override
	public void run(String... args) throws Exception {
		System.out.println("Started...");

		//check if there are specific states we are targeting
		final List<String> states = new ArrayList<String>();
		String states_env = System.getenv("STATES");
		if(states_env != null) {
			logger.info("Targeting States: " + states_env);
			states.addAll(Arrays.asList(states_env.split(",")));
		} else {
			logger.info("Targeting All States");
			states.addAll(Arrays.asList(all_states));
		}
		
		Thread thread = new Thread(new Runnable() {
			
			@SuppressWarnings("unchecked")
			@Override
			public void run() {
				RabbitClient client = RabbitClient.getInstance();
				while (true){
					Random random = new Random();
					String state = states.get(random.nextInt(states.size()));
					int value = (1+random.nextInt(4))*10;
					
					JSONObject obj = new JSONObject();
					obj.put("amount", value);
					obj.put("state", state.trim());
					try {
						client.post(obj);
					} catch (IOException e1) {
						throw new RuntimeException(e1);
					}
				
					try{
					   Thread.sleep(3000);
				    }
				    catch(Exception e){ return; }
				}

			}
		});
		
		thread.start();
		
	}	

}
