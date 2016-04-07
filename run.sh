#!/bin/bash

# Add your credentials and api endpoints here and in the cooresponding  manifests
# Change the name of an app by updating whats shown in quotes

#cf api --skip-ssl-validation http://<your_cf_api>
#cf login -u <user> -p <password> -o <org> -s <space>

cf create-service p-rabbitmq standard myrabbit
cf create-service p-service-registry standard myeureka

cf push "Service Activation Map" -f PCFDemo-map/manifest.yml --no-start
cf bind-service "Service Activation Map" myrabbit
cf bind-service "Service Activation Map" myeureka
cf restart "Service Activation Map"

cf push "Game Pilot" -f PCFDemo-producer/manifest-pilot.yml --no-start
cf bind-service "Game Pilot" myrabbit
cf bind-service "Game Pilot" myeureka
cf restart "Game Pilot" 

cf push "East Player Regions" -f PCFDemo-producer/manifest-east.yml --no-start
cf bind-service "East Player Regions" myrabbit
cf bind-service "East Player Regions" myeureka
cf restart "East Player Regions"
cf scale "East Player Regions" -i 5

cf push "South Player Regions" -f PCFDemo-producer/manifest-south.yml --no-start
cf bind-service "South Player Regions" myrabbit
cf bind-service "South Player Regions" myeureka
cf restart "South Player Regions"
cf scale "South Player Regions" -i 4
