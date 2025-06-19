# Hello Spring Boot App - Jenkins Assignment 7

This project demonstrates a simple Java Spring Boot web application, containerized with Docker, and automated using Jenkins pipelines for CI/CD. The application is deployed to a Kubernetes cluster (Minikube) as part of the workflow.

## Virtual Machine Setup
Before starting the project, two VMs were set up using Oracle VirtualBox:
- **Master VM**: Acts as the Jenkins master node.
- **Slave VM**: Acts as the Jenkins agent (slave node) for running build and deployment jobs.

This master-slave setup allows distributed builds and better resource management for CI/CD pipelines.

## Project Structure
- **HelloApplication.java**: Main Spring Boot application entry point.
- **HelloController.java**: REST controller exposing `/hello` endpoint.
- **pom.xml**: Maven build configuration.
- **Dockerfile**: Containerizes the Spring Boot app.
- **deployment.yaml**: Kubernetes manifest for deployment and service.
- **Jenkinsfile**: Jenkins pipeline for Docker build and push to DockerHub.
- **JenkinsFile_K8s**: Jenkins pipeline for building, Dockerizing, and deploying to Minikube.

## Project Folder Structure

```
hello-springboot-app/
├── deployment.yaml
├── Dockerfile
├── Jenkinsfile
├── JenkinsFile_K8s
├── pom.xml
├── README.md
├── src/
    └── main/
        ├── java/
        │   └── com/
        │       └── example/
        │           └── helloapp/
        │               ├── HelloApplication.java
        │               └── HelloController.java
        └── resources/

```

## How It Works
1. **Spring Boot App**: Exposes a `/hello` endpoint returning a greeting message.
2. **Build & Package**: Uses Maven to build a JAR file.
3. **Dockerization**: Dockerfile packages the JAR into an image.
4. **Jenkins Pipelines**:
   - `Jenkinsfile`: Builds, Dockerizes, and pushes the image to DockerHub.
   - `JenkinsFile_K8s`: Builds, Dockerizes, and deploys the app to Minikube using Kubernetes manifests.
5. **Kubernetes Deployment**: Deploys the app and exposes it via a NodePort service.

## Usage
### Prerequisites
- Java 17
- Maven
- Docker
- Jenkins
- Minikube & kubectl

### Build & Run Locally
```sh
mvn clean package
java -jar target/hello-springboot-app-1.0.0.jar
```
Visit: [http://localhost:8080/hello](http://localhost:8080/hello)

### Build Docker Image
```sh
docker build -t hello-springboot-app:latest .
```

### Run with Docker
```sh
docker run -p 8080:8080 hello-springboot-app:latest
```

### Deploy to Minikube
```sh
kubectl apply -f deployment.yaml
```

### Jenkins Pipelines
- Use `Jenkinsfile` for CI/CD with DockerHub.
- Use `JenkinsFile_K8s` for CI/CD with Minikube.

## Author
Raj Kashyap

---
This project is for educational purposes as part of DevOps Journey 2k25 assignments.

