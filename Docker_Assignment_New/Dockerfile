# Use OpenJDK base image
FROM openjdk:8

# Create app directory inside the container
WORKDIR /app

# Copy source code into the container
COPY FDemo.java .

# Compile the Java source code
RUN javac FDemo.java

# Run the application
CMD ["java", "Demo"]
