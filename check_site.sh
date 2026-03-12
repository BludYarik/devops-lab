#!/bin/bash
URL="http://localhost:8081"
CONTAINER_NAME="devops-lab_app-web_1"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)
if [ $STATUS == "200" ]; then
    echo "$(date): Site is UP ($STATUS)"
else 
    echo "$(date): Site is DOWN ($STATUS). Restarting..."
    docker restart $CONTAINER_NAME
fi

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    echo "Disk is almost full! ($DISK_USAGE%). Cleaning Docker..."
    docker system prune -f
fi