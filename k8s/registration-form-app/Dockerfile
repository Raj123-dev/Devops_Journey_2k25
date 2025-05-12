FROM openjdk:11-jre-slim
VOLUME /tmp
COPY target/registration-form-app.war registration-form-app.war
ENTRYPOINT ["java","-jar","/registration-form-app.war"]