FROM maven:3.9.6-eclipse-temurin-21-alpine AS build
WORKDIR /app
COPY pom.xml ./parent-pom.xml
RUN mvn install:install-file -Dfile=parent-pom.xml \
    -DgroupId=com.connectsphere \
    -DartifactId=connectsphere-parent \
    -Dversion=1.0.0 \
    -Dpackaging=pom \
    -q
COPY like-service/pom.xml ./pom.xml
COPY like-service/src ./src
RUN mvn package -DskipTests -q

FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8084
ENTRYPOINT ["java","-jar","app.jar"]
