#!/bin/bash

python main.py &

response=$(curl -s http://localhost:8000/health)

echo $response

if ${response['Status']} == 'healthy'; then
	echo "health check passed"
	exit 0
else
	echo "Health check failed"
	exit 1
fi
