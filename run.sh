#!/bin/bash

# Add your credentials and api endpoints here and in the cooresponding  manifests
# Change the name of an app by updating whats shown in quotes

cf api --skip-ssl-validation http://<your_cf_api>
cf login -u <user> -p <password> -o <org> -s <space>

cf create-service p-rabbitmq standard myrabbit
cf create-service p-service-registry standard myeureka

cf push "Service Activation Map" -f PCFDemo-map/manifest.yml --no-start
cf bind-service "Service Activation Map" myrabbit
cf bind-service "Service Activation Map" myeureka
cf restart "Service Activation Map"

cf push "Fantasy Sports Pilot" -f PCFDemo-producer/manifest-pilot.yml --no-start
cf bind-service "Fantasy Sports Pilot" myrabbit
cf bind-service "Fantasy Sports Pilot" myeureka
cf restart "Fantasy Sports Pilot" 

cf push "East Customer Regions" -f PCFDemo-producer/manifest-east.yml --no-start
cf bind-service "East Customer Regions" myrabbit
cf bind-service "East Customer Regions" myeureka
cf restart "East Customer Regions"
cf scale "East Customer Regions" -i 5

cf push "South Customer Regions" -f PCFDemo-producer/manifest-south.yml --no-start
cf bind-service "South Customer Regions" myrabbit
cf bind-service "South Customer Regions" myeureka
cf restart "South Customer Regions"
cf scale "South Customer Regions" -i 4
