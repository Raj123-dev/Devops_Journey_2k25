# Hello World Spring Boot Web Application

## Overview
This is a simple Spring Boot web application that displays `"Hello! That's my Java application."` on a web page. It demonstrates the basics of setting up a Spring Boot application with a REST endpoint.

## Features
- Single endpoint (`/hello`) that returns a greeting message.
- Built with Spring Boot 3.x (or 2.x).
- Uses embedded Tomcat server (default).
- Lightweight and easy to deploy.

## Tech Stack
- **Backend**: Spring Boot (Java)
- **Build Tool**: Maven
- **Packaging**: JAR (executable)

## How It Works
1. When you run the application, it starts a web server (default port: `8080`).
2. Accessing `http://localhost:8080/hello` returns:
   ```
   Hello! That's my Java application.
   ```

## Setup Instructions
1. **Requirements**:
   - Java 17+
   - Maven

2. **Run the app**:
   ```bash
   mvn spring-boot:run
   # Or
   java -jar target/hello-springboot-app.jar
   ```

3. **Test**:
   Open a browser or use `curl`:
   ```bash
   curl http://localhost:8080/hello
   ```

## Project Structure
```
src/
├── main/
│   ├── java/
│   │   └── com/example/helloapp/
│   │       ├── HelloApplication.java
│   │       └── HelloController.java
│   └── resources/
│       └── application.properties
```

## Next Steps
- Add Swagger for API docs.
- Dockerize the app.
- Extend with database connectivity.