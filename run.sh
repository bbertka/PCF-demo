#!/bin/bash

# Add your credentials and api endpoints here and in the cooresponding  manifests
# Change the name of an app by updating whats shown in quotes

cf api --skip-ssl-validation http://<your_cf_api>
cf login -u <user> -p <password> -o <org> -s <space>

cf create-service p-rabbitmq standard myrabbit
cf create-service p-service-registry standard myeureka

cf push "Service Activation Map" -f PCFDemo-map/manifest.yml
cf bind-service "Service Activation Map" myrabbit
cf bind-service "Service Activation Map" myeureka

cf push "Fantasy Sports Pilot" -f PCFDemo-producer/manifest-pilot.yml
cf bind-service "Fantasy Sports Pilot" myrabbit
cf bind-service "Fantasy Sports Pilot" myeureka

cf push "East Customer Regions" -f PCFDemo-producer/manifest-east.yml
cf bind-service "East Customer Regions" myrabbit
cf bind-service "East Customer Regions" myeureka
cf scale "East Customer Regions" -i 5

cf push "South Customer Regions" -f PCFDemo-producer/manifest-south.yml
cf bind-service "South Customer Regions" myrabbit
cf bind-service "South Customer Regions" myeureka
cf scale "South Customer Regions" -i 4
