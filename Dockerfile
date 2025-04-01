FROM maven:3.9-eclipse-temurin-21 AS build


WORKDIR /app

COPY pom.xml .

RUN mvn dependency:go-offline -B

COPY src ./src

RUN mvn package -DskipTests


FROM tomcat:8-jdk21-temurin

# Copiar el archivo WAR construido en la etapa anterior a la carpeta webapps de Tomcat
# Renombrarlo a ROOT.war hace que la aplicación se despliegue en el contexto raíz (/)
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
