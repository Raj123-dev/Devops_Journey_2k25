# Flask User Registration App with CI/CD



This project is a simple Flask web application for user registration and listing, using SQLite as the database. The app is containerized with Docker and uses Jenkins for CI/CD to build, push, and deploy the Docker image.

## Deployment on AWS EC2



This project was deployed using an AWS EC2 instance (t2.micro):

- Launched a t2.micro EC2 instance (Ubuntu) on AWS.
- Connected to the instance using command prompt (SSH):
  ```bash
  ssh -i your-key.pem ubuntu@your-ec2-public-dns
  ```
- Installed Jenkins on the EC2 instance:
  ```bash
  sudo apt update
  sudo apt install -y openjdk-17-jdk
  # Add Jenkins repository key
  curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  # Add Jenkins repository to apt sources
  echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
  sudo apt update
  sudo apt install -y jenkins
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  ```
- Configured security group inbound rules:
  - Opened port 8080 for Jenkins access from your IP.
  - Opened port 6001 for Flask app access from your IP.
- Installed Docker on the EC2 instance:
  ```bash
  sudo apt update
  sudo apt install -y ca-certificates curl gnupg
  sudo install -m 0755 -d /etc/apt/keyrings
  # Add Docker's official GPG key
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  # Add Docker repository to apt sources
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update
  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  sudo usermod -aG docker jenkins
  sudo systemctl restart jenkins
  ```
- Configured Jenkins to use Docker for building and running the Flask app.
- Used the Jenkins pipeline to automate build, push, and deployment steps.

**Note:**
- Ensure Jenkins and Flask ports are open in the EC2 security group inbound rules.


## Features
- Register new users (name, email)
- List all registered users
- Data stored in SQLite database
- Responsive UI with Bootstrap
- Dockerized for easy deployment
- Jenkins pipeline for automated build, push, and deployment

## Project Structure
```
Datadog/
├── app.py                # Main Flask application
├── requirements.txt      # Python dependencies
├── Dockerfile            # Docker build instructions
├── Jenkinsfile           # Jenkins pipeline definition
├── instance/
│   └── users.db          # SQLite database (auto-created)
└── templates/
    ├── base.html         # Base template
    ├── index.html        # User list page
    └── register.html     # Registration form
```

## Setup & Usage

### 1. Local Development
1. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
2. Run the app:
   ```bash
   python app.py
   ```
3. Access at [http://localhost:5000](http://localhost:5000)

### 2. Docker
1. Build the image:
   ```bash
   docker build -t rajkashyap12/flask-cicd-app:latest .
   ```
2. Run the container:
   ```bash
   docker run -d -p 5000:5000 --name flask-app rajkashyap12/flask-cicd-app:latest
   ```

### 3. Jenkins CI/CD
- The `Jenkinsfile` automates:
  - Checkout from source control
  - Build Docker image
  - Push to Docker Hub (`rajkashyap12/flask-cicd-app`)
  - Deploys the container (removes old, runs new)
- Make sure Jenkins has Docker and Docker Hub credentials set up.
- The pipeline uses `sh` steps for Ubuntu/Linux agents.

## Common Issues Faced
- **Windows vs Linux Jenkins agents:**
  - Use `sh` for Ubuntu/Linux, `bat` for Windows. This pipeline uses `sh`.
- **Database file not persisting:**
  - The SQLite DB is created in the `instance/` folder. For production, consider using a volume or a more robust DB.
- **Docker permission errors in Jenkins:**
  - Ensure Jenkins user has permission to run Docker commands (add to `docker` group).
- **Credentials:**
  - Docker Hub credentials must be set in Jenkins with the ID `dockerhub`.



