# AWS CodePipeline Assignment: Deploy Spring Boot App to EKS

This assignment demonstrates how to automate the CI/CD process for a Java Spring Boot application using AWS CodePipeline, CodeBuild, Docker Hub, and Amazon EKS.

---

## 🚀 Overview
- **Source:** GitHub/CodeCommit repository
- **Build:** AWS CodeBuild (Maven build, Docker build, push to Docker Hub)
- **Deploy:** CodeBuild (envsubst + kubectl apply to EKS)

---

## 📝 Prerequisites
- AWS account with permissions for CodePipeline, CodeBuild, EKS, and Secrets Manager
- EKS cluster set up and accessible
- Docker Hub account and repository
- Code and Kubernetes manifests in your repository
- Docker Hub credentials stored in AWS Secrets Manager (e.g., `dockerhub/credentials`)

---

## 🗂️ Project Structure (Example)
```
Devops_Journey_2k25/
├── Jenkins_Assignment_7/
│   └── hello-springboot-app/
│       ├── Dockerfile
│       ├── aws_deployment.yaml
│       └── ...
├── buildspec.yml
├── buildspec_deploy.yml
└── README.md
```

---

## ⚙️ Pipeline Steps (as per buildspec.yml)
1. **pre_build:**
   - Logs in to Docker Hub using credentials from environment variables.
   - Sets `IMAGE_TAG` to the first 7 characters of the commit SHA.
2. **build:**
   - Builds the Spring Boot JAR with Maven.
   - Builds and pushes the Docker image to Docker Hub with the tag `$IMAGE_TAG`.
3. **post_build:**
   - Updates kubeconfig for EKS.
   - Uses `envsubst` to substitute `${IMAGE_TAG}` in `aws_deployment.yaml` and creates `final_deployment.yaml`.
   - Deploys to EKS using `kubectl apply -f final_deployment.yaml`.

---

## 📄 Example `aws_deployment.yaml` (image field)
```yaml
containers:
  - name: hello-springboot-app
    image: rajkashyap12/hello-springboot-app:${IMAGE_TAG}
```

---

## 📄 Example `buildspec.yml`
```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - echo Logging in to Docker Hub...
      - echo $DOCKERHUB_PASSWORD | docker login --username $DOCKERHUB_USERNAME --password-stdin
      - IMAGE_TAG=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - export IMAGE_TAG
      - echo "IMAGE_TAG=$IMAGE_TAG"
  build:
    commands:
      - echo Building the Maven project..
      - mvn clean package
      - echo Building the Docker image...
      - docker build -t rajkashyap12/hello-springboot-app:$IMAGE_TAG -f Jenkins_Assignment_7/hello-springboot-app/Dockerfile Jenkins_Assignment_7/hello-springboot-app
      - docker push rajkashyap12/hello-springboot-app:$IMAGE_TAG
  post_build:
    commands:
      - echo Applying Kubernetes manifests to EKS...
      - aws eks update-kubeconfig --region $AWS_REGION --name $EKS_CLUSTER_NAME
      - export IMAGE_TAG=$IMAGE_TAG
      - envsubst < Jenkins_Assignment_7/hello-springboot-app/aws_deployment.yaml > final_deployment.yaml
      - kubectl apply -f final_deployment.yaml
```

---

## 📄 Example `buildspec_deploy.yml` (Service Verification)
```yaml
version: 0.2
phases:
  pre_build:
    commands:
      - echo "Setting up kubeconfig..."
      - aws eks update-kubeconfig --region us-east-1 --name my-cluster
  build:
    commands:
      - echo "Fetching service details from EKS..."
      - SERVICE_NAME="hello-springboot-app-service"
      - NODE_PORT=$(kubectl get svc $SERVICE_NAME -o jsonpath='{.spec.ports[0].nodePort}')
      - NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type==\"ExternalIP\")].address}')
      - >
        if [ -z "$NODE_PORT" ] || [ -z "$NODE_IP" ]; then
          echo "❌ Failed to fetch NODE_IP or NODE_PORT";
          exit 1;
        else
          echo "✅ Application is running at: http://$NODE_IP:$NODE_PORT";
        fi
```

### What this does:
- Sets up kubeconfig for your EKS cluster.
- Fetches the NodePort and ExternalIP for your service (`hello-springboot-app-service`).
- Prints the public URL for your application if available, or fails with an error if not.

---

## 🔑 Environment Variables
- `DOCKERHUB_USERNAME` and `DOCKERHUB_PASSWORD` (from Secrets Manager)
- `AWS_REGION` (e.g., `us-east-1`)
- `EKS_CLUSTER_NAME` (your EKS cluster name)

---

## ✅ How It Works
1. Push code to your repository.
2. CodePipeline triggers and runs CodeBuild.
3. CodeBuild builds and pushes the Docker image to Docker Hub.
4. Substitutes the image tag in the Kubernetes manifest.
5. Deploys the updated manifest to EKS.

---

## 👤 Author
Raj Kashyap

---
This project is for educational purposes as part of DevOps Journey 2k25 assignments.
