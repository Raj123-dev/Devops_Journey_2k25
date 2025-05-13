#!/bin/bash
set -e

if [ "$1" == "clean" ]; then
  if [ "$2" == "helm" ]; then
    echo "[HELM CLEAN] Uninstalling Helm release..."
    helm uninstall kubernetes-form-webapp || true
    exit 0
  fi
  echo "[CLEAN] Deleting all Kubernetes resources for the app..."
  kubectl delete -f ingress.yaml || true
  kubectl delete -f tomcat-deployment.yaml || true
  kubectl delete -f mysql-deployment.yaml || true
  echo "[CLEAN] Stopping minikube tunnel if running..."
  pkill -f "minikube tunnel" || true
  echo "[CLEAN] Cleanup complete."
  exit 0
fi

if [ "$1" == "helm" ] || [ "$2" == "helm" ]; then
  echo "[HELM] Building Docker image for Tomcat app..."
  eval $(minikube docker-env)
  docker build -t kubernetes-form-webapp:latest .
  echo "[HELM] Installing/Upgrading Helm chart..."
  helm upgrade --install kubernetes-form-webapp ./helm
  minikube addons enable ingress
  kubectl wait --namespace kube-system --for=condition=ready pod -l app.kubernetes.io/name=ingress-nginx --timeout=120s || true
  minikube tunnel &
  MINIKUBE_IP=$(minikube ip)
  echo "\nHelm deployment complete!"
  echo "\nOpen your browser and go to: http://$MINIKUBE_IP/"
  echo "\nIf you don't see the app, try: http://$MINIKUBE_IP/ or http://$MINIKUBE_IP:30080/"
  exit 0
fi

echo "[0/5] Applying MySQL init ConfigMap..."
kubectl apply -f mysql-initdb-configmap.yaml

echo "[1/5] Building Docker image for Tomcat app..."
eval $(minikube docker-env)
docker build -t kubernetes-form-webapp:latest .

echo "[2/5] Applying MySQL deployment..."
kubectl apply -f mysql-deployment.yaml

echo "[3/5] Waiting for MySQL pod to be ready..."
kubectl wait --for=condition=ready pod -l app=mysql --timeout=120s

echo "[4/5] Deploying Tomcat app..."
kubectl apply -f tomcat-deployment.yaml

echo "[5/5] Setting up Ingress..."
kubectl apply -f ingress.yaml

# Enable ingress addon if not already enabled
minikube addons enable ingress

# Wait for ingress controller
kubectl wait --namespace kube-system --for=condition=ready pod -l app.kubernetes.io/name=ingress-nginx --timeout=120s || true

# Forward port 5000 on host to ingress controller
minikube tunnel &

# Get Minikube IP and print access URL
MINIKUBE_IP=$(minikube ip)
echo "\nDeployment complete!"
echo "\nOpen your browser and go to: http://$MINIKUBE_IP/"
echo "\nIf you don't see the app, try: http://$MINIKUBE_IP/ or http://$MINIKUBE_IP:30080/"
