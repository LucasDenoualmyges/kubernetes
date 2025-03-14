FORM amazoncorretto:17-alpine
WORKDIR /app
COPY target/paymybuddy.jar /app/
EXPOSE 8080
CMD ["java", "-jar", "paymybuddy.jar"]
