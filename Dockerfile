# First stage: Builder
FROM node:18-alpine as builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY . .

# Second stage: Production
FROM node:18-alpine

WORKDIR /usr/src/app

# Copy only necessary files from builder
COPY --from=builder /usr/src/app/node_modules ./node_modules
COPY --from=builder /usr/src/app/server.js .

EXPOSE 3000

# Use non-root user for better security
USER node

CMD ["node", "server.js"]

