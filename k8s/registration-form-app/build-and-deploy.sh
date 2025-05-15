#!/bin/bash

set -e  # Exit immediately on error

# Variables
IMAGE_NAME="rajkashyap12/registration-form-app:latest"
DEPLOYMENT_FILE="kubernetes/deployment.yaml"
SERVICE_FILE="kubernetes/service.yaml"
MYSQL_DEPLOYMENT_FILE="kubernetes/mysql-deployment.yaml"
MYSQL_SERVICE_FILE="kubernetes/mysql-service.yaml"
WAR_SOURCE="target/registration-form-app-1.0-SNAPSHOT.war"
WAR_DEST="target/registration-form-app.war"

# Step 1: Build the WAR file using Maven
echo "🔨 Building the WAR file..."
mvn clean package

# Rename WAR file if needed
if [ -f "$WAR_SOURCE" ]; then
  mv "$WAR_SOURCE" "$WAR_DEST"
  echo "✅ WAR file renamed to $WAR_DEST"
else
  echo "❌ Error: WAR file not found at $WAR_SOURCE"
  exit 1
fi

# Step 2: Build the Docker image
echo "🐳 Building the Docker image..."
docker build -t "$IMAGE_NAME" .

# Step 3: Push the Docker image
echo "📤 Pushing the Docker image to Docker Hub..."
if docker push "$IMAGE_NAME"; then
  echo "✅ Docker image pushed successfully to $IMAGE_NAME"
else
  echo "❌ Docker push failed. Please run: docker login"
  exit 1
fi

# Step 4: Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
  echo "❌ kubectl is not installed. Please install kubectl and try again."
  exit 1
fi

# Step 5: Apply Kubernetes configurations for MySQL
echo "🚀 Deploying MySQL to Kubernetes..."
kubectl apply -f "$MYSQL_DEPLOYMENT_FILE"
kubectl apply -f "$MYSQL_SERVICE_FILE"

# Step 6: Apply Kubernetes configurations for your application
echo "🚀 Deploying the registration-form app to Kubernetes..."
kubectl apply -f "$DEPLOYMENT_FILE" --validate=false
kubectl apply -f "$SERVICE_FILE" --validate=false

# Step 7: Output Node IP and Port
echo "⏳ Waiting for services to become available..."
sleep 5
NODE_IP=$(minikube ip)
NODE_PORT=$(kubectl get svc registration-form-service -o=jsonpath='{.spec.ports[0].nodePort}')

echo "✅ Application deployed successfully!"
echo "🌐 Access it at: http://$NODE_IP:$NODE_PORT"
