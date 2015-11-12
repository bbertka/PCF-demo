#!/bin/bash

cf push -f manifest-test.yml
sleep 5
cf push -f manifest-east.yml
sleep 5
cf scale "East Customer Region" -i 5
sleep 10
cf push -f manifest-south.yml
sleep 5
cf scale "South Customer Region" -i 4
sleep 20
cf scale "South Customer Region" -i 2
cf scale "East Customer Region" -i 2
cf delete "XFINITY Fantasy Football Pilot" -f
