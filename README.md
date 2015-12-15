PCF Demo - Spring Boot Microservices, Netflix OSS, and Jenkins Pipeline
=========

This is the Spring Boot refactoring for the PCF-Demo app built with two different micro-services: 

- The producer (generating orders) 
- The map (consuming orders and presenting on the heat map)

The apps/micro-services are connected through a RabbitMQ instance of any name and all the information exchanged is JSON based.
The map will be active as the PCF-demo-producer micro-service is started. To freeze the map, just stop the service.

Service discovery is enabled with Netflix OSS Eureka via Spring Cloud Service Discovery service.

For convenience, a manifest which will push both micro-services at the same time is provided, assuming a RabbitMQ service called "myrabbit" is created, as well as a Spring Cloud Services Service Discovery (Eureka) service "myeureka" is also created.

The manifest.yml file for the pcfdemo-map application must be update to set the appropriate CF API values; CF_USERNAME, CF_PASSWORD and CF_ENDPOINT.  CF_ENDPOINT should be specified specified in the format of 'api.some.url.to.com' (http:// is omitted)

For both apps, an environent variable called CF_TARGET must be updated to your api endpoint (https:// is included) -- note this is a redundancy required by Spring Cloud Service Discovery and will be merged with the CF_ENDPOINT variable in an update to this codebase.

The pcfdemo-producer app(s) may be tailored to send data to target specific states.  To configure this set an env variable on the application called STATES and set the value to a comma-delimited list of states you wish to target.  E.G. STATES: "ny,nj,pa"

To run, build the following projects first:

- PCFDemo-producer: ./gradlew assemble
- PCFDemo-map: ./gradlew assemble

General Instructions for deployment on PCF
- cf api [your cf api url]
- cf login 
- cf create-service p-rabbitmq standard myrabbit (for PWS: "cf create-service cloudamqp lemur myrabbit")
- cf create-service p-service-registry standard myeureka
- cf push

Remember:  free RabbitMQ service on PWS (a.k.a. "CloudAMQP" plan "lemur") is limited to 3 connections max. For that, you can demo two instances of the map (still able to show self-healing and load-balancing) and one instance of the producer.

For deploying this demo through Jenkins, see instructions here: https://github.com/bbertka/PCF-demo/blob/micro-services/Deploy-microservices-CD.adoc

Note, to change the company logo, a 151x33px png with transparency is ideal.
 
Enjoy!!
