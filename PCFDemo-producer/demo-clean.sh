#!/bin/bash
cf delete "South Customer Region" -f
cf delete "East Customer Region" -f
cf delete "Fantasy Football Pilot" -f
curl -k https://comcast.vert.fe.gopivotal.com/clear
