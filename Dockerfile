# # Use an OpenJDK base image
 
# FROM openjdk:11-jre-slim
 
 
# # Set working directory in the container
 
# WORKDIR /app
 
# # Copy the JAR file into the container
 
# COPY target/BankingMicroservice1-1.0-SNAPSHOT.jar app.jar
 
 
# # Expose the application port (adjust if needed)
 
# EXPOSE 8080
 
 
# # Command to run the JAR file
 
# ENTRYPOINT ["java", "-jar", "app.jar"]


# Use an OpenJDK base image (Java 17)
FROM openjdk:17-jre-slim

# Set working directory in the container
WORKDIR /app

# Copy the JAR file into the container
COPY target/BankingMicroservice1-1.0-SNAPSHOT.jar app.jar

# Expose the application port (adjust if needed)
EXPOSE 8080

# Command to run the JAR file
ENTRYPOINT ["java", "-jar", "app.jar"]
