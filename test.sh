#!/bin/bash

python main.py &

response=$(curl -s http://localhost:8000/health)

echo $response

if response['status'] == 'healthy'; then
	echo "health check passed"
	exit 0
else;
	echo "Health chcek failed"
	exit 1
fi
