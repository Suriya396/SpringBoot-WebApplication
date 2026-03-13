# -------- STAGE 1 : BUILD --------
FROM maven:3.9.9-eclipse-temurin-17 AS build

WORKDIR /build

# copy pom first (better caching)
COPY pom.xml .

# download dependencies (fast rebuilds)
RUN mvn -B -q -e -DskipTests dependency:go-offline

# copy source
COPY src ./src

# build jar
RUN mvn -B clean package -DskipTests


# -------- STAGE 2 : RUN --------
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# copy jar from build stage
COPY --from=build /build/target/*.jar app.jar

# expose app port
EXPOSE 8080

# run app
ENTRYPOINT ["java","-jar","app.jar"]
