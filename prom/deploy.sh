#!/bin/bash
# Build Docker image for Minikube's Docker daemon
eval $(minikube docker-env)
docker build -t flask-app:latest .

# Deploy using Helm chart
helm upgrade --install flask-app ./helm-chart

echo "Deployment started. To access your app, run: minikube service flask-service"
