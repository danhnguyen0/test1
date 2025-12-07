# Stage 1: Builder
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker cache
COPY package.json package-lock.json ./

# Install dependencies, including devDependencies for the build process
RUN npm ci

# Copy the rest of the application source code
COPY . .

# Build the Next.js application
# This generates the .next directory
RUN npm run build

# Stage 2: Runner
FROM node:20-alpine AS runner

WORKDIR /app

# Set environment to production
ENV NODE_ENV=production

# Copy only necessary files for running the application from the builder stage
# - package.json and package-lock.json for npm start command
# - node_modules with only production dependencies
# - The built Next.js application (.next directory)
# - The custom server files
COPY --from=builder /app/package.json ./package.json
COPY --from=builder /app/package-lock.json ./package-lock.json

# Install only production dependencies for the runtime image
RUN npm ci --omit=dev

COPY --from=builder /app/.next ./.next
COPY --from=builder /app/server.js ./server.js
COPY --from=builder /app/createServer.js ./createServer.js

# Expose the port the app listens on (default for Next.js/Express)
EXPOSE 3000

# Command to run the application in production
CMD ["npm", "start"]