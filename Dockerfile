# Use an official Gradle image to build the app
FROM gradle:8.5.0-jdk17 AS builder

# Set working directory
WORKDIR /app

# Copy only necessary files first to cache dependencies
COPY build.gradle.kts settings.gradle.kts ./
COPY gradle ./gradle

RUN gradle build --no-daemon || return 0

# Copy the full source code
COPY . .

# Build the project
RUN gradle build --no-daemon

# Use a minimal JDK base image to run the app
FROM eclipse-temurin:17-jdk-alpine

# Set working directory
WORKDIR /app

# Copy the built jar from the builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]
