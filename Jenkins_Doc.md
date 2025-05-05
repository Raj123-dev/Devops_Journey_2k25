
# Jenkins - All Basic Concepts 

---

## 🔹 What is Jenkins?
- Jenkins is an **open-source automation server**.
- It helps in **Continuous Integration and Continuous Delivery (CI/CD)**.
- Jenkins automates the process of building, testing, and deploying applications.

---

## 🔹 CI/CD Explained
- **CI (Continuous Integration)**: Developers push code frequently, Jenkins automatically builds & tests it.
- **CD (Continuous Delivery/Deployment)**: After testing, Jenkins automatically deploys code to production or staging.

---

## 🔹 Jenkins Architecture
- **Jenkins Master**: Controls the overall flow (UI, scheduling).
- **Jenkins Agent/Slave**: Executes jobs assigned by master (can be on different machines).
- You can scale Jenkins using multiple agents.

---

## 🔹 Types of Jenkins Projects
1. **Freestyle Project**
   - GUI-based configuration.
   - Easy to use but limited in flexibility.

2. **Pipeline Project**
   - Code-based using **Jenkinsfile**.
   - More control, suitable for complex CI/CD workflows.

---

## 🔹 Jenkinsfile
- It defines the CI/CD pipeline as code.
- Written in Groovy language.

**Example:**
```groovy
pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        echo 'Building...'
      }
    }
    stage('Test') {
      steps {
        echo 'Testing...'
      }
    }
    stage('Deploy') {
      steps {
        echo 'Deploying...'
      }
    }
  }
}
```

---

## 🔹 Declarative vs Scripted Pipeline
| Declarative Pipeline | Scripted Pipeline         |
|----------------------|---------------------------|
| Easy syntax          | Full programming control  |
| Uses `pipeline` block| Uses `node` block         |
| Better for beginners | More flexible             |

---

## 🔹 Blue Ocean
- A modern UI for Jenkins pipelines.
- Provides visual representation of stages, errors, and builds.
- Easy to monitor and debug pipelines.

---

## 🔹 Cron Job in Jenkins
- Used to schedule jobs (like a timer).
- Syntax:
```
MIN HOUR DOM MON DOW
```
**Example**: Run every day at 6AM
```
0 6 * * *
```

---

## 🔹 Parameters in Jenkins
- Used to make jobs dynamic.
- You can pass values like string, boolean, choice, etc.

**Example**: Choice Parameter for environment
```groovy
parameters {
  choice(name: 'ENV', choices: ['dev', 'test', 'prod'], description: 'Select Environment')
}
```

---

## 🔹 Webhook in Jenkins
- Webhooks trigger Jenkins jobs automatically when code is pushed to GitHub/GitLab.
- Use **Git plugin** or **GitHub Integration** to set it up.

---

## 🔹 Jenkins Plugins
- Jenkins supports 1000+ plugins to integrate with tools like Git, Maven, Docker, Slack, etc.

---

## 🔹 Jenkins with Docker
- Jenkins itself can run inside Docker.
- You can also use Docker inside Jenkins pipelines to build containerized applications.

---

## 🔹 Sample Jenkins Pipeline for Node.js
```groovy
pipeline {
  agent any
  stages {
    stage('Install') {
      steps {
        bat 'npm install'
      }
    }
    stage('Test') {
      steps {
        bat 'npm test'
      }
    }
    stage('Build Image') {
      steps {
        bat 'docker build -t my-node-app .'
      }
    }
  }
}
```

---

## ✅ Summary:
- Jenkins is an automation tool for building, testing, and deploying software.
- Freestyle = Simple GUI project.
- Pipeline = Code-based and flexible.
- Use Jenkinsfile for CI/CD.
- Plugins and Blue Ocean enhance its capability.
- Cron, Parameters, and Webhooks add automation & flexibility.

---


