# Makefile for Next.js 15 Template with Bun
# Author: Generated for nextjs-15-template
# Usage: make <target>

.PHONY: help install update clean dev build start type-check lint format check fix db-generate db-migrate db-seed db-reset docker-build docker-run docker-dev docker-logs docker-db docker-shell docker-migrate docker-seed docker-clean ngrok

# Colors for output
CYAN := \033[36m
GREEN := \033[32m
YELLOW := \033[33m
RED := \033[31m
RESET := \033[0m

# Default target
.DEFAULT_GOAL := help

# Help target
help: ## Display available commands
	@echo "$(CYAN)Available commands:$(RESET)"
	@echo ""
	@echo "$(GREEN)Package Management:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(install|update|clean):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Development:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(dev|build|start|type-check):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Code Quality:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(lint|format|check|fix):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Database (Prisma):$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(db-):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Docker:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(docker-):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'
	@echo ""
	@echo "$(GREEN)Utilities:$(RESET)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | grep -E '^(ngrok):' | awk 'BEGIN{FS = ":.*?## "}; {printf "  $(CYAN)%-15s$(RESET) %s\n", $$1, $$2}'

# Package Management
install: ## Install dependencies using bun
	@echo "$(GREEN)Installing dependencies with bun...$(RESET)"
	bun install

update: ## Update dependencies
	@echo "$(GREEN)Updating dependencies...$(RESET)"
	bun update

clean: ## Clean node_modules and lock files
	@echo "$(YELLOW)Cleaning node_modules and lock files...$(RESET)"
	rm -rf node_modules
	rm -f bun.lockb
	@echo "$(GREEN)Clean complete. Run 'make install' to reinstall dependencies.$(RESET)"

# Development Commands
dev: ## Start development server with Turbopack
	@echo "$(GREEN)Starting development server with Turbopack...$(RESET)"
	bun run dev

build: ## Build for production
	@echo "$(GREEN)Building for production...$(RESET)"
	bun run build

start: ## Start production server
	@echo "$(GREEN)Starting production server...$(RESET)"
	bun run start

type-check: ## Run TypeScript type checking
	@echo "$(GREEN)Running TypeScript type check...$(RESET)"
	bunx tsc --noEmit

# Code Quality & Formatting
lint: ## Run ESLint with auto-fix
	@echo "$(GREEN)Running ESLint with auto-fix...$(RESET)"
	bun run eslint

format: ## Run Prettier formatting
	@echo "$(GREEN)Running Prettier formatting...$(RESET)"
	bun run prettier

check: ## Check code quality (lint + format without fixing)
	@echo "$(GREEN)Checking code quality...$(RESET)"
	bunx eslint src --ext .ts,.tsx,.js,.jsx
	bunx prettier --check .

fix: ## Fix all code quality issues
	@echo "$(GREEN)Fixing all code quality issues...$(RESET)"
	bun run lint

# Database Operations (Prisma)
db-generate: ## Generate Prisma client
	@echo "$(GREEN)Generating Prisma client...$(RESET)"
	bun run prisma:generate

db-migrate: ## Run database migrations for PostgreSQL
	@echo "$(GREEN)Running database migrations...$(RESET)"
	bun run prisma:migrate

db-seed: ## Seed database with test data
	@echo "$(GREEN)Seeding database...$(RESET)"
	bun run seed

db-reset: ## Reset database (migrate + seed)
	@echo "$(YELLOW)Resetting database...$(RESET)"
	bun run prisma:migrate
	bun run seed
	@echo "$(GREEN)Database reset complete.$(RESET)"

# Docker Operations
docker-build: ## Build Docker image
	@echo "$(GREEN)Building Docker image for PostgreSQL setup...$(RESET)"
	docker build -t nextjs-15-template .

docker-run: ## Run Docker container (standalone)
	@echo "$(GREEN)Running standalone Docker container...$(RESET)"
	@echo "$(YELLOW)Note: Use 'make docker-dev' for complete development environment with PostgreSQL$(RESET)"
	docker run -p 3000:3000 --name nextjs-15-template-container nextjs-15-template

docker-dev: ## Start complete development environment (PostgreSQL + App)
	@echo "$(GREEN)Starting Docker development environment with PostgreSQL...$(RESET)"
	docker compose up -d
	@echo "$(GREEN)Environment started! Access at http://localhost:3000$(RESET)"
	@echo "$(CYAN)PostgreSQL: localhost:5432 (user: nextjs_user, db: nextjs_template)$(RESET)"

docker-logs: ## View Docker container logs
	@echo "$(GREEN)Viewing Docker logs...$(RESET)"
	docker compose logs -f

docker-db: ## Connect to PostgreSQL database
	@echo "$(GREEN)Connecting to PostgreSQL database...$(RESET)"
	docker compose exec postgres psql -U nextjs_user -d nextjs_template

docker-shell: ## Access app container shell
	@echo "$(GREEN)Accessing app container shell...$(RESET)"
	docker compose exec app sh

docker-migrate: ## Run database migrations in Docker
	@echo "$(GREEN)Running database migrations in Docker...$(RESET)"
	docker compose exec app bun run prisma:migrate

docker-seed: ## Seed database in Docker
	@echo "$(GREEN)Seeding database in Docker...$(RESET)"
	docker compose exec app bun run seed

docker-clean: ## Clean Docker containers, images and volumes
	@echo "$(YELLOW)Cleaning Docker containers, images and volumes...$(RESET)"
	-docker compose down -v
	-docker stop nextjs-15-template-container
	-docker rm nextjs-15-template-container
	-docker rmi nextjs-15-template
	docker system prune -f
	@echo "$(GREEN)Docker cleanup complete!$(RESET)"

# Utilities
ngrok: ## Start ngrok tunnel for webhooks testing
	@echo "$(GREEN)Starting ngrok tunnel on port 3000...$(RESET)"
	bun run ngrok

# Combined workflows
setup: install db-generate ## Complete project setup (install + generate)
	@echo "$(GREEN)Project setup complete!$(RESET)"

reset: clean install db-generate ## Full reset (clean + install + generate)
	@echo "$(GREEN)Full project reset complete!$(RESET)"

production: build start ## Build and start production server
	@echo "$(GREEN)Production deployment complete!$(RESET)"

# Quality assurance workflow
qa: check type-check ## Run all quality checks
	@echo "$(GREEN)All quality checks passed!$(RESET)"

# Development workflow
dev-setup: install db-generate dev ## Setup and start development
	@echo "$(GREEN)Development environment ready!$(RESET)"