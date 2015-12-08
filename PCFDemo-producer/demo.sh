#!/bin/bash

cf push -f manifest-pilot.yml
cf push -f manifest-east.yml
cf scale "East Customer Region" -i 5
cf push -f manifest-south.yml
cf scale "South Customer Region" -i 4
