


## Architecture

```
User <-> Flask App (K8s Pod) <-> SQLite (PVC)
           |
        /metrics
           |
      Prometheus <-> Alertmanager <-> Email
           |
        Grafana
```

---

## Prerequisites

- [Minikube](https://minikube.sigs.k8s.io/docs/) installed and running
- [kubectl](https://kubernetes.io/docs/tasks/tools/) configured
- [Helm](https://helm.sh/) installed
- Docker (for building the app image)

---

## Setup Instructions

### 1. Start Minikube

```sh
minikube start
```

### 2. Build and Deploy the Flask App

```sh
cd prom
eval $(minikube docker-env)           # Use Minikube's Docker daemon
docker build -t flask-app:latest .    # Build the Docker image

# Deploy using Helm
./deploy.sh
```

This will:
- Build the Docker image
- Deploy the app, service, and persistent volume using the Helm chart in [`prom/helm-chart`](prom/helm-chart/).

### 3. Install Prometheus & Grafana

Add the Prometheus Community Helm repo and install the kube-prometheus-stack:

```sh
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --wait \
  --timeout=10m
```

Check pods:

```sh
kubectl get pods -n monitoring
```

### 4. Configure Prometheus Scraping

- The Flask app exposes metrics at `/metrics` (handled by [`prometheus_flask_exporter`](prom/requirements.txt)).
- Prometheus is configured to scrape the app using the static config in [`additional-scrape-configs.yaml`](prom/additional-scrape-configs.yaml).
- Apply the scrape config as a Kubernetes secret and reference it in your Prometheus values (see [`prometheus-values.yaml`](prom/prometheus-values.yaml)).

Example scrape config:

```yaml
- job_name: 'flask-app'
  metrics_path: /metrics
  static_configs:
    - targets: ['<minikube-ip>:<nodeport>']
  scheme: http
  scrape_interval: 30s
  scrape_timeout: 10s
```

### 5. Set Up Alerting

- PrometheusRule for Flask app downtime is defined in [`flask-app-alerts.yaml`](prom/flask-app-alerts.yaml).
- Alertmanager is configured to send email notifications.

Apply the alert rule and secret:

```sh
kubectl apply -f prom/flask-app-alerts.yaml
```

### 6. Access the Application and Dashboards

#### Flask App

Expose the service:

```sh
minikube service flask-service
```

Or, if using Helm chart:

```sh
minikube service flask-app
```

#### Grafana

Get the admin password:

```sh
kubectl get secrets prometheus-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 -d ; echo
```

Port-forward Grafana:

```sh
kubectl --namespace monitoring port-forward svc/prometheus-grafana 3000:80
```

Access [http://localhost:3000](http://localhost:3000) (default user `admin`, password: from above).

#### Prometheus

Port-forward Prometheus:

```sh
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
```

Access [http://localhost:9090](http://localhost:9090).

---

## Useful Commands

- List all services:
  ```sh
  kubectl get svc -n monitoring
  ```
- List all deployments:
  ```sh
  kubectl get deployment -n monitoring
  ```
- Check logs for Grafana:
  ```sh
  kubectl logs <grafana-pod-name> -c grafana
  ```

---

## Important Commands

Below are the essential commands used to deploy, configure, and manage the Flask app, Prometheus, and Grafana monitoring stack. These commands have been tested and verified in this project workflow.

---

### 1. Build and Deploy the Flask App

```sh
# Build the Docker image using Minikube's Docker daemon
eval $(minikube docker-env)
docker build -t flask-app:latest .

# Deploy the app using Helm (if you have a Helm chart)
./deploy.sh
```

---

### 2. Create and Update Prometheus Additional Scrape Config

```sh
# Create or update the additional scrape configs secret
kubectl create secret generic additional-scrape-configs \
  --from-file=additional-scrape-configs.yaml=./additional-scrape-configs.yaml \
  -n monitoring --dry-run=client -o yaml | kubectl apply -f -
```

---

### 3. Upgrade Prometheus Stack with Custom Values

```sh
# Upgrade (or install) the Prometheus stack with your custom values
helm upgrade prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring -f ./prometheus-values.yaml
```

---

### 4. Apply Prometheus Alert Rules and Alertmanager Config

```sh
# Apply the PrometheusRule for Flask app alerts and Alertmanager config
kubectl apply -f flask-app-alerts.yaml
```

---

### 5. Restart StatefulSets (if config changes)

```sh
# Restart Prometheus StatefulSet
kubectl rollout restart statefulset prometheus-prometheus-kube-prometheus-prometheus -n monitoring

# Restart Alertmanager StatefulSet
kubectl rollout restart statefulset alertmanager-prometheus-kube-prometheus-alertmanager -n monitoring
```

---

### 5. Update helm

# Restart Alertmanager StatefulSet
helm repo update
```
---

### 6. Scale Flask App Deployment (for testing alerts)

```sh
# Scale down to simulate downtime
kubectl scale deployment flask-app --replicas=0

# Scale up to restore service
kubectl scale deployment flask-app --replicas=1
```

---

### 7. Access Grafana and Prometheus Dashboards

```sh
# Get Grafana admin password
kubectl --namespace monitoring get secrets prometheus-grafana -o jsonpath="{.data.admin-password}" | base64 -d ; echo

# Port-forward Grafana to localhost:3000
export POD_NAME=$(kubectl --namespace monitoring get pod -l "app.kubernetes.io/name=grafana,app.kubernetes.io/instance=prometheus" -oname)
kubectl --namespace monitoring port-forward $POD_NAME 3000

# Port-forward Prometheus to localhost:9090
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
```

---

### 8. Useful Monitoring and Debugging

```sh
# List all PrometheusRule resources
kubectl get prometheusrules -n monitoring

# Describe a specific PrometheusRule
kubectl describe prometheusrules flask-app-alerts -n monitoring

# Check Alertmanager pod status
kubectl get pods -n monitoring | grep alertmanager
```

---

**Tip:**  
Repeat the `kubectl create secret generic additional-scrape-configs ...` and `helm upgrade ...` commands whenever you update your scrape configs or Prometheus values.

---

**Enjoy monitoring your Flask app with Prometheus and Grafana!**
