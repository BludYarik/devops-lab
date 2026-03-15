#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

URL="http://localhost:8081"
CONTAINER_NAME="devops-lab_app-web_1"

STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

if [ "$STATUS" == "200" ]; then
    echo -e "${GREEN}✔${NC} $(date): Site is ${GREEN}UP ($STATUS)${NC}"
else 
    echo -e "${RED}✘${NC} $(date): Site is ${RED}DOWN ($STATUS)${NC}. ${YELLOW}Trying to Restart${NC} ${CONTAINER_NAME}..."

    docker restart $CONTAINER_NAME > /dev/null || (cd ~/devops-lab && docker-compose down && docker-compose up -d)
    sleep 2
    NEW_STATUS=$(curl -s -o /dev/null -w "%{http_code}" $URL)

    [ "$(docker ps -q -f name=^/${CONTAINER_NAME}$ -f status=running)" ] && echo -e "${GREEN}---Restarting DONE(${NEW_STATUS})---${NC}"
fi

DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ "$DISK_USAGE" -gt 90 ]; then
    echo "Disk is almost full! ($DISK_USAGE%). Cleaning Docker..."
    docker system prune -f
fi
