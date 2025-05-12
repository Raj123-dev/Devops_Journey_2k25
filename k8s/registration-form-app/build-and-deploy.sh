#!/bin/bash

# Step 1: Build the WAR file using Maven
echo "Building the WAR file..."
mvn clean package

# Step 2: Build the Docker image
echo "Building the Docker image..."
docker build -t registration-app:latest .

# Step 3: Apply Kubernetes configurations
echo "Deploying the application to Kubernetes..."

# Apply the deployment YAML
kubectl apply -f kubernetes/deployment.yaml

# Apply the service YAML
kubectl apply -f kubernetes/service.yaml

echo "Application deployed successfully!"
echo "Access the application at http://<NodeIP>:<NodePort>"
