# 🚀 Hello Spring Boot App - Jenkins Assignment 7

This project demonstrates a simple Java Spring Boot web application, containerized with Docker, and automated using Jenkins pipelines for CI/CD. The application is deployed to a Kubernetes cluster (Minikube) as part of the workflow.

## 🖥️ Virtual Machine Setup
Before starting the project, two VMs were set up using Oracle VirtualBox:
- 🖥️ **Master VM**: Acts as the Jenkins master node. Jenkins was installed and accessed via a web browser on this VM.
- 🖥️ **Slave VM**: Acts as the Jenkins agent (slave node) for running build and deployment jobs.

This master-slave setup allows distributed builds and better resource management for CI/CD pipelines.

## ⚙️ Jenkins Setup
After installing Jenkins on the master VM:
1. 🌐 Open Jenkins in your web browser (usually at `http://<master-vm-ip>:8080`).
2. 🔑 Complete the initial setup wizard:
   - Unlock Jenkins using the administrator password from `/var/lib/jenkins/secrets/initialAdminPassword`.
   - Install suggested plugins.
   - Create your first admin user.
3. 🛠️ Configure system settings as needed (e.g., tools, global credentials).
4. ➕ Add the slave VM as a Jenkins agent for distributed builds.

## 🤖 Step-by-Step: Adding and Connecting a Jenkins Slave Node (Agent)

1. **Create the Agent Node in Jenkins (Master VM):**
   - ➕ Go to **Manage Jenkins** > **Manage Nodes and Clouds**.
   - ➕ Click **New Node**.
   - 📝 Enter a name (e.g., `Slave_node`), select **Permanent Agent**, and click OK.
   - 🔢 Set the number of executors to **2**.
   - 🗂️ Enter the remote root directory as **/opt/build**.
   - 🏷️ Set the labels (e.g., `Slave_node`) to match your pipeline configuration.
   - ⚡ Choose the launch method: **Launch agent by connecting it to the controller** (JNLP/agent.jar method).
   - 💾 Save the node configuration.

2. **Prepare the Slave VM:**
   - 🗂️ Manually create the `/opt/build` directory on the slave VM:
     ```sh
     sudo mkdir -p /opt/build
     sudo chown jenkins:jenkins /opt/build
     ```
   - 📁 This directory is created at the root (`/`) of the filesystem and will be used by Jenkins for job workspaces and files.

3. **Transfer agent.jar to the Slave VM:**
   - 📥 Download `agent.jar` from the Jenkins master (controller). If the slave VM cannot download it directly, use `scp` to transfer it:
     ```sh
     # Run this command on your local machine or the master VM
     scp jenkins@<master-vm-ip>:/path/to/agent.jar jenkins@<slave-vm-ip>:/home/jenkins/agent.jar
     ```

4. **Connect the Slave Node to Jenkins:**
   - 🔗 In the Jenkins UI on the master VM, open the configuration page for your `Slave_node`.
   - 📋 Copy the Java command provided (it includes the JNLP URL and secret).
   - 💻 Paste and run this command on the slave VM to connect the agent to the Jenkins master:
     ```sh
     java -jar /home/jenkins/agent.jar -jnlpUrl http://<master-vm-ip>:8080/computer/Slave_node/jenkins-agent.jnlp -secret <secret-key> -workDir "/opt/build"
     ```
   - ✅ Once executed, the slave node will appear as "connected" in the Jenkins UI and will be ready to run jobs.

## 🐳 Docker Credentials Setup in Jenkins
To enable Jenkins to push Docker images to DockerHub, set up Docker credentials:
1. 🔐 In Jenkins, go to **Manage Jenkins** > **Manage Credentials**.
2. 🌍 Select the appropriate domain (or use "(global)")).
3. ➕ Click **Add Credentials**.
4. 👤 Choose **Username with password** as the kind.
5. 📝 Enter your DockerHub username and use a **Docker Hub access token** (not your password) for enhanced security.
6. 🏷️ Set the ID to `rajkashyap12` (or the ID referenced in your Jenkinsfile).
7. 💾 Save the credentials.

Jenkins pipelines can now use these credentials to authenticate with DockerHub securely.

## 📦 Project Structure
- `HelloApplication.java`: Main Spring Boot application entry point.
- `HelloController.java`: REST controller exposing `/hello` endpoint.
- `pom.xml`: Maven build configuration.
- `Dockerfile`: Containerizes the Spring Boot app.
- `deployment.yaml`: Kubernetes manifest for deployment and service.
- `Jenkinsfile`: Jenkins pipeline for Docker build and push to DockerHub.
- `JenkinsFile_K8s`: Jenkins pipeline for building, Dockerizing, and deploying to Minikube.

## 📁 Project Folder Structure

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
        └── java/
            └── com/
                └── example/
                    └── helloapp/
                        ├── HelloApplication.java
                        └── HelloController.java
```

## ⚙️ How It Works
1. 🌐 **Spring Boot App**: Exposes a `/hello` endpoint returning a greeting message.
2. 🏗️ **Build & Package**: Uses Maven to build a JAR file.
3. 🐳 **Dockerization**: Dockerfile packages the JAR into an image.
4. 🤖 **Jenkins Pipelines**:
   - `Jenkinsfile`: Builds, Dockerizes, and pushes the image to DockerHub.
   - `JenkinsFile_K8s`: Builds, Dockerizes, and deploys the app to Minikube using Kubernetes manifests.
5. ☸️ **Kubernetes Deployment**: Deploys the app and exposes it via a NodePort service.

## 📝 Usage
### 🔧 Prerequisites
- ☕ Java 17
- 🐘 Maven
- 🐳 Docker
- 🤖 Jenkins
- ☸️ Minikube & kubectl

### ▶️ Build & Run Locally
```sh
mvn clean package
java -jar target/hello-springboot-app-1.0.0.jar
```
Visit: [http://localhost:8080/hello](http://localhost:8080/hello)

### 🐳 Build Docker Image
```sh
docker build -t hello-springboot-app:latest .
```

### 🐳 Run with Docker
```sh
docker run -p 8080:8080 hello-springboot-app:latest
```

### ☸️ Deploy to Minikube
```sh
kubectl apply -f deployment.yaml
```

### 🤖 Jenkins Pipelines
- Use `Jenkinsfile` for CI/CD with DockerHub.
- Use `JenkinsFile_K8s` for CI/CD with Minikube.

## Example buildspec.yml for AWS CodePipeline with Docker Hub

```yaml
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Docker Hub...
      - echo $DOCKERHUB_PASSWORD | docker login --username rajkashyap12 --password-stdin
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - echo Building the Maven project...
      - mvn clean package
      - echo Building the Docker image...
      - docker build -t rajkashyap12/hello-springboot-app:$IMAGE_TAG .
      - docker push rajkashyap12/hello-springboot-app:$IMAGE_TAG
  post_build:
    commands:
      - echo Updating deployment.yaml with new image...
      - sed -i "s|image:.*|image: rajkashyap12/hello-springboot-app:$IMAGE_TAG|g" deployment.yaml
      - echo Applying Kubernetes manifests to EKS...
      - aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME
      - kubectl apply -f deployment.yaml
artifacts:
  files:
    - deployment.yaml
```

- Set your Docker Hub password as the `DOCKERHUB_PASSWORD` environment variable in CodeBuild (preferably using AWS Secrets Manager).
- Set `AWS_REGION` and `EKS_CLUSTER_NAME` as environment variables in CodeBuild.

## 📚 Reference: Jenkins Agent Working Directory and agent.jar

- 🗂️ The Jenkins agent (slave node) uses `/opt/build` as its remote root directory, created at the root (`/`) of the filesystem on the slave VM. All Jenkins job workspaces, build files, and temporary files for jobs running on the agent will be stored under this directory.
- 📥 When adding a new slave node (agent) in Jenkins using the "Launch agent by connecting it to the controller" method, Jenkins provides a command to run on the slave VM. This command downloads the `agent.jar` file from the Jenkins master (controller) to the slave VM, or you can transfer it using `scp` if needed.
- 🔗 The `agent.jar` file is responsible for establishing a connection between the slave node and the Jenkins master, allowing the agent to receive and execute jobs.



---
This project is for educational purposes as part of DevOps Journey 2k25 assignments.

