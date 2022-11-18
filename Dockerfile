#FROM openjdk:8-jdk-alpine - having alot of vulnerabilities with Critical and High severity
FROM openjdk
EXPOSE 8080
ARG JAR_FILE=target/*.jar
ADD ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
