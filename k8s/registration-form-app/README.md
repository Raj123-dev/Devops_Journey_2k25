# Registration Form Application

This project is a web-based registration form application built using HTML, Java Servlets, and MySQL. It is hosted on Apache Tomcat and deployed on Kubernetes.

## Features

- User registration with form validation
- User login functionality
- Interaction with a MySQL database for storing user information
- Dockerized application for easy deployment
- Kubernetes configuration for managing application deployment

## Project Structure

```
registration-form-app
├── src
│   ├── main
│   │   ├── java
│   │   │   ├── com
│   │   │   │   └── example
│   │   │   │       ├── servlets
│   │   │   │       │   ├── RegistrationServlet.java
│   │   │   │       │   └── LoginServlet.java
│   │   │   │       └── utils
│   │   │   │           └── DatabaseConnection.java
│   │   ├── resources
│   │   │   └── application.properties
│   │   └── webapp
│   │       ├── WEB-INF
│   │       │   ├── web.xml
│   │       └── views
│   │           ├── index.html
│   │           ├── registration.html
│   │           └── login.html
├── Dockerfile
├── kubernetes
│   ├── deployment.yaml
│   ├── service.yaml
│   └── configmap.yaml
├── pom.xml
└── README.md
```

## Setup Instructions

1. **Clone the repository:**
   ```
   git clone <repository-url>
   cd registration-form-app
   ```

2. **Configure the database:**
   - Update the `src/main/resources/application.properties` file with your MySQL database connection details.

3. **Build the project:**
   ```
   mvn clean install
   ```

4. **Build the Docker image:**
   ```
   docker build -t registration-form-app .
   ```

5. **Deploy to Kubernetes:**
   - Apply the Kubernetes configurations:
   ```
   kubectl apply -f kubernetes/
   ```

6. **Access the application:**
   - Once deployed, access the application through the service endpoint defined in `kubernetes/service.yaml`.

## Usage

- Navigate to the registration page to create a new account.
- Use the login page to access your account.

## Contributing

Feel free to submit issues or pull requests for improvements or bug fixes.