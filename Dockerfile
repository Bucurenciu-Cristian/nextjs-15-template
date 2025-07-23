# Use an official Node.js runtime as a base image
FROM node:20.19.3-alpine

# Build arguments for user ID matching (improves bind mount permissions)
ARG UID=1000
ARG GID=1000

# Set working directory
WORKDIR /usr/app

# Install bun globally and PostgreSQL client for health checks
RUN npm install -g bun && apk add --no-cache postgresql-client

# Create node user with configurable UID/GID for host compatibility
# This prevents permission issues with bind mounts in development
RUN deluser --remove-home node 2>/dev/null || true && \
    addgroup -g ${GID} -S nodegroup && \
    adduser -u ${UID} -G nodegroup -S -D -h /home/node node

# Copy package.json, bun.lockb, and prisma directory with proper ownership
COPY --chown=node:nodegroup package.json bun.lockb* ./
COPY --chown=node:nodegroup prisma ./prisma

# Install dependencies using bun (this will run postinstall which needs prisma)
RUN bun install --frozen-lockfile

# Copy entrypoint script with correct ownership and permissions
COPY --chown=node:nodegroup --chmod=755 docker-entrypoint.sh /usr/local/bin/

# Copy all remaining application files with proper ownership
COPY --chown=node:nodegroup ./ ./

# Build app for production (commented out for development)
#RUN bun run build

# Switch to non-root user for security
USER node

# Expose the listening port
EXPOSE 3000

# Launch app with custom entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["bun", "run", "dev"]
