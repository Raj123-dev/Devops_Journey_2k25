# Use the official Tomcat base image
FROM tomcat:9.0

# Set the working directory (optional, Tomcat already has this set)
WORKDIR /usr/local/tomcat

# Remove default ROOT if it exists
RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy the WAR file of your application to the Tomcat webapps directory
COPY target/registration-form-app.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
