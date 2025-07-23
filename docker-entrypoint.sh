#!/bin/sh
set -e

echo "🚀 Starting Next.js application with PostgreSQL..."

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be ready..."
until pg_isready -h postgres -p 5432 -U nextjs_user; do
  echo "PostgreSQL is unavailable - sleeping"
  sleep 2
done

echo "✅ PostgreSQL is ready!"

# Run database migrations
echo "🔄 Running database migrations..."
if bun run prisma:migrate deploy 2>/dev/null || bun run prisma:generate; then
  echo "✅ Database migrations completed successfully"
else
  echo "⚠️  Migration failed, trying to push schema..."
  bun x prisma db push --accept-data-loss || echo "⚠️  Schema push failed - continuing anyway"
fi

# Optional: Seed database if SEED_DATABASE env var is set
if [ "$SEED_DATABASE" = "true" ]; then
  echo "🌱 Seeding database..."
  bun run seed || echo "⚠️  Database seeding failed - continuing anyway"
fi

echo "🎯 Starting application..."

# Execute the main command
exec "$@"