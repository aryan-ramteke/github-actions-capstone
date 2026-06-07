#!/bin/bash

python main.py &

sleep 5

response=$(curl -s http://localhost:8000/health)

echo $response

status=$(echo "$response" | jq -r .Status)

if [ "$status" = 'healthy' ]; then
	echo "health check passed"
	exit 0
else
	echo "Health check failed"
	exit 1
fi
