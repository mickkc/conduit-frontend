FROM node:20-alpine

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install
RUN npm install -g http-server

# Copy the rest of the application
COPY . .

ENV APP_PORT=3000

# Replace API_URL in environment.ts with the value from the build argument
ARG API_URL
RUN sed -i "s|API_URL|${API_URL}|g" /app/src/environments/environment.ts

# Build the application
RUN npm run build --configuration=production

# Expose the app port
EXPOSE $APP_PORT

RUN chmod +x entrypoint.sh

# Start the application
ENTRYPOINT ["sh", "-c", "http-server /app/dist/angular-conduit -p ${APP_PORT}"]