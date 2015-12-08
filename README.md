PCF Demo
=========
***Update***
This project is under development for porting to Spring Boot Gradle. Projects must be rebuilt:

- PCFDemo-producer: ./gradlew build
- PCFDemo-map: mvn package

This is the refactoring for the PCF-Demo app built with two different micro-services: 

- The producer (generating orders) - written in Groovy with SpringBoot 
- The map (consuming orders and presenting on the heat map) - written in Java with Spring Web MVC.

The apps/micro-services are connected through a RabbitMQ instance of any name and all the information exchanged is JSON based.
The map will be active as the PCF-demo-producer micro-service is started. To freeze the map, just stop the service.

For convenience, a manifest which will push both micro-services at the same time is provided, assuming a RabbitMQ service called "myrabbit" is created.

A script for pushing to PWS is also provided, which will create a space called "pcf-demo", create the service required and push both micro-services to it.

The manifest.yml file for the pcfdemo-map application must be update to set the appropriate CF API values; CF_USERNAME, CF_PASSWORD and CF_ENDPOINT.  CF_ENDPOINT should be specified specified in the format of 'api.some.url.to.com' (http:// is omitted)

The pcfdemo-producer app(s) may be tailored to send data to target specific states.  To configure this set an env variable on the application called STATES and set the value to a comma-delimited list of states you wish to target.  E.G. STATES: "ny,nj,pa"

Instructions for deployment on PCF
- cf api [your cf api url]
- cf login 
- cf create-service p-rabbitmq standard myrabbit (for PWS: "cf create-service cloudamqp lemur myrabbit")
- cf push

Remember:  free RabbitMQ service on PWS (a.k.a. "CloudAMQP" plan "lemur") is limited to 3 connections max. For that, you can demo two instances of the map (still able to show self-healing and load-balancing) and one instance of the producer.

For deploying this demo through Jenkins, see instructions here: https://github.com/bbertka/PCF-demo/blob/micro-services/Deploy-microservices-CD.adoc

Note, to change the company logo, a 151x33px png with transparency is ideal.
 
Enjoy!!
