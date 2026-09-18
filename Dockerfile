FROM gradle:6.5-jdk8 AS build
WORKDIR /app
COPY build.gradle settings.gradle ./
COPY gradle ./gradle
COPY gradlew .
RUN ./gradlew dependencies --no-daemon
COPY src ./src
RUN ./gradlew build -x test --no-daemon

FROM eclipse-temurin:8-jre-alpine AS runtime
WORKDIR /app
RUN addgroup -S spring && adduser -S spring -G spring
USER spring
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]