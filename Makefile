# Makefile for Next.js 15 Template with Bun
# Author: Generated for nextjs-15-template
# Usage: make <target>

.PHONY: help install update clean dev build start type-check lint format check fix db-generate db-migrate db-seed db-reset docker-build docker-run docker-dev docker-logs docker-db docker-shell docker-migrate docker-seed docker-clean ngrok

# Emojis for output (terminal-friendly)
INFO := 🔷
SUCCESS := ✅
WARNING := ⚠️
ERROR := ❌

# Default target
.DEFAULT_GOAL := help

# Help target
help: ## Display available commands
	@echo "$(INFO) Available commands:"
	@echo ""
	@echo "$(SUCCESS) Package Management:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(install|update|clean):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(INFO) %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "$(SUCCESS) Development:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(dev|build|start|type-check):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(INFO) %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "$(SUCCESS) Code Quality:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(lint|format|check|fix):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(INFO) %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "$(SUCCESS) Database (Prisma):"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(db-):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(INFO) %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "$(SUCCESS) Docker:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(docker-):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(INFO) %-15s %s\n", $$1, $$2}'
	@echo ""
	@echo "$(SUCCESS) Utilities:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(ngrok):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(INFO) %-15s %s\n", $$1, $$2}'

# Package Management
install: ## Install dependencies using bun
	@echo "$(SUCCESS) Installing dependencies with bun..."
	bun install

update: ## Update dependencies
	@echo "$(SUCCESS) Updating dependencies..."
	bun update

clean: ## Clean node_modules and lock files
	@echo "$(WARNING) Cleaning node_modules and lock files..."
	rm -rf node_modules
	rm -f bun.lockb
	@echo "$(SUCCESS) Clean complete. Run 'make install' to reinstall dependencies."

# Development Commands
dev: ## Start development server with Turbopack
	@echo "$(SUCCESS) Starting development server with Turbopack..."
	bun run dev

build: ## Build for production
	@echo "$(SUCCESS) Building for production..."
	bun run build

start: ## Start production server
	@echo "$(SUCCESS) Starting production server..."
	bun run start

type-check: ## Run TypeScript type checking
	@echo "$(SUCCESS) Running TypeScript type check..."
	bunx tsc --noEmit

# Code Quality & Formatting
lint: ## Run ESLint with auto-fix
	@echo "$(SUCCESS) Running ESLint with auto-fix..."
	bun run eslint

format: ## Run Prettier formatting
	@echo "$(SUCCESS) Running Prettier formatting..."
	bun run prettier

check: ## Check code quality (lint + format without fixing)
	@echo "$(SUCCESS) Checking code quality..."
	bunx eslint src --ext .ts,.tsx,.js,.jsx
	bunx prettier --check .

fix: ## Fix all code quality issues
	@echo "$(SUCCESS) Fixing all code quality issues..."
	bun run lint

# Database Operations (Prisma)
db-generate: ## Generate Prisma client
	@echo "$(SUCCESS) Generating Prisma client..."
	bun run prisma:generate

db-migrate: ## Run database migrations for PostgreSQL
	@echo "$(SUCCESS) Running database migrations..."
	bun run prisma:migrate

db-seed: ## Seed database with test data
	@echo "$(SUCCESS) Seeding database..."
	bun run seed

db-reset: ## Reset database (migrate + seed)
	@echo "$(WARNING) Resetting database..."
	bun run prisma:migrate
	bun run seed
	@echo "$(SUCCESS) Database reset complete."

# Docker Operations
docker-build: ## Build Docker image
	@echo "$(GREEN)Building Docker image for PostgreSQL setup...$(RESET)"
	docker build -t nextjs-15-template .

docker-run: ## Run Docker container (standalone)
	@echo "$(SUCCESS) Running standalone Docker container..."
	@echo "$(WARNING) Note: Use 'make docker-dev' for complete development environment with PostgreSQL"
	docker run -p 3000:3000 --name nextjs-15-template-container nextjs-15-template

docker-dev: ## Start complete development environment (PostgreSQL + App)
	@echo "$(SUCCESS) Starting Docker development environment with PostgreSQL..."
	docker compose up -d
	@echo "$(SUCCESS) Environment started! Access at http://localhost:3000"
	@echo "$(INFO) PostgreSQL: localhost:5432 (user: nextjs_user, db: nextjs_template)"

docker-logs: ## View Docker container logs
	@echo "$(SUCCESS) Viewing Docker logs..."
	docker compose logs -f

docker-db: ## Connect to PostgreSQL database
	@echo "$(SUCCESS) Connecting to PostgreSQL database..."
	docker compose exec postgres psql -U nextjs_user -d nextjs_template

docker-shell: ## Access app container shell
	@echo "$(SUCCESS) Accessing app container shell..."
	docker compose exec app sh

docker-migrate: ## Run database migrations in Docker
	@echo "$(SUCCESS) Running database migrations in Docker..."
	docker compose exec app bun run prisma:migrate

docker-seed: ## Seed database in Docker
	@echo "$(SUCCESS) Seeding database in Docker..."
	docker compose exec app bun run seed

docker-clean: ## Clean Docker containers, images and volumes
	@echo "$(WARNING) Cleaning Docker containers, images and volumes..."
	-docker compose down -v
	-docker stop nextjs-15-template-container
	-docker rm nextjs-15-template-container
	-docker rmi nextjs-15-template
	docker system prune -f
	@echo "$(SUCCESS) Docker cleanup complete!"

# Utilities
ngrok: ## Start ngrok tunnel for webhooks testing
	@echo "$(SUCCESS) Starting ngrok tunnel on port 3000..."
	bun run ngrok

# Combined workflows
setup: install db-generate ## Complete project setup (install + generate)
	@echo "$(SUCCESS) Project setup complete!"

reset: clean install db-generate ## Full reset (clean + install + generate)
	@echo "$(SUCCESS) Full project reset complete!"

production: build start ## Build and start production server
	@echo "$(SUCCESS) Production deployment complete!"

# Quality assurance workflow
qa: check type-check ## Run all quality checks
	@echo "$(SUCCESS) All quality checks passed!"

# Development workflow
dev-setup: install db-generate dev ## Setup and start development
	@echo "$(SUCCESS) Development environment ready!"
