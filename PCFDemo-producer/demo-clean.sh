#!/bin/bash
cf delete "South Customer Region" -f
cf delete "Customer Region" -f
cf delete "XFINITY Fantasy Football Pilot" -f
curl -k https://comcast.vert.fe.gopivotal.com/clear