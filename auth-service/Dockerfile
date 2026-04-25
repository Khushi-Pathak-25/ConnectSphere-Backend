FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app

# Copy root parent pom.xml first so Maven can resolve connectsphere-parent
COPY pom.xml ./parent-pom.xml
RUN mvn install:install-file -Dfile=parent-pom.xml \
    -DgroupId=com.connectsphere \
    -DartifactId=connectsphere-parent \
    -Dversion=1.0.0 \
    -Dpackaging=pom \
    -q

# Now build the service
COPY auth-service/pom.xml ./pom.xml
COPY auth-service/src ./src
RUN mvn package -DskipTests -q

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8081
ENTRYPOINT ["java","-jar","app.jar"]
