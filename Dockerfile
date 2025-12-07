# Stage 1: Build the Next.js application
FROM node:20-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker cache
COPY package.json package.json
COPY package-lock.json package-lock.json

# Install dependencies
RUN npm ci

# Copy the rest of your application code
COPY . .

# Build the Next.js application
RUN npm run build

# Stage 2: Run the Next.js application in production
FROM node:20-alpine AS runner

WORKDIR /app

# Set production environment
ENV NODE_ENV=production

# Expose the application port
EXPOSE 3000

# Copy necessary files from the builder stage
COPY --from=builder /app/package.json package.json
COPY --from=builder /app/package-lock.json package-lock.json
COPY --from=builder /app/server.js server.js
COPY --from=builder /app/createServer.js createServer.js
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules

# Command to run the application
# This uses the "start" script defined in package.json, which is "NODE_ENV=production node server.js"
CMD ["npm", "start"]