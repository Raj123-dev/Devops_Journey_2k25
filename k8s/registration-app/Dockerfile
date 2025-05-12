# Use the official Tomcat image as the base image
FROM tomcat:9.0

# Copy the WAR file to the webapps directory of Tomcat
COPY target/registration-app.war /usr/local/tomcat/webapps/registration-app.war

# Expose port 8080
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]
