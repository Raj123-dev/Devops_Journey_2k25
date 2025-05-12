# Use the official Tomcat base image
FROM tomcat:9.0

# Set the working directory
WORKDIR /usr/local/tomcat

# Copy the WAR file of your application to the Tomcat webapps directory
COPY target/registration-form-app.war /usr/local/tomcat/webapps/

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]