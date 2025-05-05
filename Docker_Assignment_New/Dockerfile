
 



# Use a Debian-based OpenJDK image with APT support

FROM openjdk:17-jdk-slim
 
# Install necessary libraries for GUI apps

RUN apt-get update && apt-get install -y \

    libxext6 \

    libxrender1 \

    libxtst6 \

    libxi6 \

    libgtk2.0-0 \
&& rm -rf /var/lib/apt/lists/*
 
# Create app directory inside the container
WORKDIR /app

# Copy source code into the container
COPY Demo.java .

# Compile the Java source code
RUN javac Demo.java

# Run the application
CMD ["java", "Demo"]
