# Use an official Node.js runtime as a base image
FROM node:20.19.3-alpine

# Set working directory
WORKDIR /usr/app

# Install bun globally and PostgreSQL client for health checks
RUN npm install -g bun && apk add --no-cache postgresql-client

# Copy package.json, bun.lockb, and prisma directory for dependency installation
COPY package.json bun.lockb* ./
COPY prisma ./prisma

# Install dependencies using bun (this will run postinstall which needs prisma)
RUN bun install --frozen-lockfile

# Change ownership to the non-root user
RUN chown -R node:node /usr/app

# Copy all remaining files
COPY ./ ./

# Build app for production (commented out for development)
#RUN bun run build

# Expose the listening port
EXPOSE 3000

# Run container as non-root (unprivileged) user
# The "node" user is provided in the Node.js Alpine base image
USER node

# Create entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Launch app with custom entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bun", "run", "dev"]
