# Use OpenJDK base image
FROM openjdk:17-alpine

# Set working directory
WORKDIR /app

# Copy Java source file
COPY App.java .

# Compile Java file
RUN javac App.java

# Expose port 8000
EXPOSE 8000

# Run the Java application
CMD ["java", "App"]
