pipeline {
    agent any

    tools {
        maven 'Maven' // Ensure this version is configured in Jenkins
        jdk 'Java'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/Raj123-dev/Devops_Journey_2k25.git'

            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean install'
            }
        }

        

        stage('Deploy') {
            steps {
                echo 'Deploying... (placeholder)'
                // your deployment logic here
            }
        }
    }
}

