#!/bin/bash

cf push -f manifest-test.yml
cf push -f manifest-east.yml
cf scale "Customer Region" -i 5
cf push -f manifest-south.yml
cf scale "South Customer Region" -i 4
