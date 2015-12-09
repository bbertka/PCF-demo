package io.pivotal.cf.sample;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class PcfDemoBootMapApplication {
    public static void main(String[] args) {
        SpringApplication.run(PcfDemoBootMapApplication.class, args);
    }
}
