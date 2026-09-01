# ---- Backend build ----
FROM maven:3.9-eclipse-temurin-17 AS backend-build
WORKDIR /build
COPY springboot/pom.xml .
RUN mvn -q dependency:go-offline
COPY springboot/src ./src
RUN mvn -q package -DskipTests

# ---- Frontend build (Vue 3 + Vite) ----
FROM node:20-alpine AS frontend-build
WORKDIR /build
COPY vue3/package*.json ./
RUN npm install --registry=https://registry.npmmirror.com
COPY vue3/ .
RUN npm run build

# ---- Runtime ----
FROM eclipse-temurin:17-jre
WORKDIR /app
COPY --from=backend-build /build/target/*.jar app.jar
COPY --from=frontend-build /build/dist /app/static
EXPOSE 1234
ENTRYPOINT ["java", "-jar", "app.jar"]
