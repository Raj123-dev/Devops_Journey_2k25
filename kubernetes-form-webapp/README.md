# Kubernetes Form WebApp

A Java Servlet web application (JSP + Servlet + MySQL) containerized and deployable on Kubernetes using either raw manifests or Helm charts. The app features a modern HTML/CSS form UI, a Java backend, and persistent MySQL storage.

## Features
- Java Servlet backend (Tomcat)
- JSP frontend with a styled form
- MySQL database (with persistent storage)
- Kubernetes manifests and Helm chart for easy deployment
- Automated MySQL schema initialization
- One-command deploy/clean scripts

## Requirements
- Docker
- Minikube
- Helm
- kubectl
- Maven (mvn)
- JDK 11

## How to Run

### 1. Build and Deploy with Raw Kubernetes Manifests

```bash
./deploy.sh run
```
- Builds the Docker image, applies all Kubernetes manifests, initializes the MySQL schema, and exposes the app via Ingress.
- Access the app at: `http://<minikube_ip>/`

### 2. Clean Up Raw Kubernetes Deployment

```bash
./deploy.sh clean
```
- Deletes all Kubernetes resources and stops the Minikube tunnel.

### 3. Deploy Using Helm

```bash
./deploy.sh helm
```
OR
```bash
./deploy.sh run helm
```
- Builds the Docker image, installs/upgrades the Helm chart, and exposes the app via Ingress.
- Access the app at: `http://<minikube_ip>/`

### 4. Clean Up Helm Deployment

```bash
./deploy.sh clean helm
```
- Uninstalls the Helm release and cleans up all resources.

## How to Check MySQL Data

1. Get the name of the MySQL pod:
   ```bash
   kubectl get pods
   # Look for a pod with a name like mysql-xxxxxxx-xxxxx
   ```
2. Open a MySQL shell in the pod (replace <mysql-pod-name> with your pod name):
   ```bash
   kubectl exec -it <mysql-pod-name> -- mysql -uk8suser -pk8spassword k8sformdb
   ```
3. Once inside the MySQL shell, you can run the following commands:

   - **Show all databases:**
     ```sql
     SHOW DATABASES;
     ```
   - **Select your database:**
     ```sql
     USE k8sformdb;
     ```
   - **Show all tables in the current database:**
     ```sql
     SHOW TABLES;
     ```
   - **Describe the structure of the `users` table:**
     ```sql
     DESCRIBE users;
     ```
   - **See all data stored in the `users` table:**
     ```sql
     SELECT * FROM users;
     ```

## Notes
- The MySQL schema is initialized automatically on first deployment using a ConfigMap and the `/docker-entrypoint-initdb.d` mechanism.
- The app is available at the root path (`/`) of your Minikube IP.
- Make sure Docker is using the Minikube Docker daemon (`eval $(minikube docker-env)`) if building images locally.

## Directory Structure
- `src/` - Java source and JSP files
- `helm/` - Helm chart templates and values
- `*.yaml` - Raw Kubernetes manifests
- `deploy.sh` - Unified deployment/cleanup script

---

For any issues, check pod logs with `kubectl logs <pod-name>` or inspect resources with `kubectl get all`.
