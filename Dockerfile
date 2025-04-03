FROM maven:3.9-eclipse-temurin-21 AS build


WORKDIR /app

COPY pom.xml .
COPY backend/pom.xml ./backend/
COPY frontend/pom.xml ./frontend/

RUN --mount=type=cache,target=/root/.m2 mvn dependency:go-offline -B

COPY backend ./backend
COPY frontend ./frontend

RUN --mount=type=cache,target=/root/.m2 mvn package -DskipTests


FROM tomcat:8-jdk21-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/backend/target/api.war /usr/local/tomcat/webapps/api.war
COPY --from=build /app/frontend/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
