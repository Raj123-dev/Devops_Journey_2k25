#!/bin/bash

# Step 1: Build the WAR file using Maven
echo "Building the WAR file..."
mvn clean package

# Check if the WAR file exists
if [ ! -f target/registration-form-app.war ]; then
  echo "Error: WAR file not found. Ensure the Maven build is successful."
  exit 1
fi

# Step 2: Build the Docker image
echo "Building the Docker image..."
docker build -t registration-app:latest .

# Step 3: Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
  echo "Error: kubectl is not installed. Please install kubectl and try again."
  exit 1
fi

# Step 4: Apply Kubernetes configurations
echo "Deploying the application to Kubernetes..."

# Apply the deployment YAML
kubectl apply -f kubernetes/deployment.yaml

# Apply the service YAML
kubectl apply -f kubernetes/service.yaml

echo "Application deployed successfully!"
echo "Access the application at http://<NodeIP>:<NodePort>"
