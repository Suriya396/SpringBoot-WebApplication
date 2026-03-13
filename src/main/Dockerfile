# -------- STAGE 1 : BUILD --------
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /build

# copy only required files (faster caching)
COPY pom.xml .
RUN mvn -B -q -e -DskipTests dependency:go-offline

COPY src ./src

RUN mvn -B clean package -DskipTests


# -------- STAGE 2 : RUN --------
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# copy jar from build stage
COPY --from=build /build/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
