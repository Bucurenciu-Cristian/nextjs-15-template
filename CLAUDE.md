# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a production-ready Next.js 15 boilerplate with TypeScript, featuring:
- App Router architecture with React 19
- PostgreSQL + Prisma ORM for data persistence
- Clerk authentication with webhook integration
- Light/dark theme support via next-themes
- React Query (TanStack Query) for data fetching
- Tailwind CSS v4 with custom design tokens

## Development Commands

### Core Development
```bash
# Start development server with Turbopack
yarn dev

# Build for production
yarn build

# Start production server
yarn start

# Lint and format code
yarn lint                    # Runs both ESLint and Prettier
yarn eslint                  # ESLint only with auto-fix
yarn prettier                # Prettier formatting
yarn format                  # Combined linting and formatting
```

### Database Commands
```bash
# Generate Prisma client
yarn prisma:generate

# Push schema to PostgreSQL / run migrations
yarn prisma:migrate

# Seed database (requires ts-node)
yarn seed

# Note: Prisma client is auto-generated on postinstall and postbuild
```

### Development Tools
```bash
# Start ngrok tunnel (for webhooks testing)
yarn ngrok
```

## Architecture Overview

### App Router Structure
The application uses Next.js 15 App Router with the following key routes:
- `/` - Public landing page
- `/posts` - Blog posts listing
- `/dashboard` - Protected user dashboard
- `/sign-in` and `/sign-up` - Clerk authentication pages
- `/api/posts` - REST API endpoint for posts
- `/api/webhooks/clerk` - Webhook handler for Clerk events

### Authentication Flow
1. **Clerk Integration**: Handles all authentication via Clerk's hosted UI
2. **Webhook Sync**: User creation/updates synced to PostgreSQL via webhooks
3. **Middleware Protection**: Routes protected via middleware.tsx
4. **User Model**: Clerk users synchronized to Prisma User model

### Data Architecture
- **Database**: PostgreSQL with Prisma ORM
- **Models**: User, Post, Comment with relational structure
- **Data Fetching**: React Query for client-side caching and synchronization
- **API Pattern**: Server actions and route handlers for data mutations

### Component Architecture
```
components/
├── ui/           # Reusable UI primitives (buttons, inputs, etc.)
├── inputs/       # Form-specific input components
├── Header/       # Site header and navigation
├── Footer/       # Site footer
├── PostCard.tsx  # Blog post display component
└── ThemeToggle.tsx  # Dark/light mode switcher
```

### State Management
- **Server State**: React Query with custom hooks (e.g., `usePosts`)
- **Local State**: Custom hooks like `useLocalStorage` for persistence
- **Theme State**: next-themes provider for theme management
- **API Calls**: Custom `useApiCall` hook for consistent error handling

## Key Dependencies and Their Purpose

### Core Framework
- **next@15.2.5**: React framework with App Router
- **react@19.0.0**: Latest React with enhanced features
- **typescript@5.8.3**: Type safety throughout the application

### Styling
- **@tailwindcss/cli@4.1.4**: New Tailwind CSS v4 with performance improvements
- **tailwind-merge**: Utility for merging Tailwind classes safely
- **class-variance-authority**: Type-safe component variants

### Data & State
- **@prisma/client**: PostgreSQL ORM with type safety
- **@tanstack/react-query**: Server state management
- **axios**: HTTP client for API calls

### Authentication
- **@clerk/nextjs**: Complete authentication solution
- **svix**: Webhook verification for Clerk events

### UI Components
- **lucide-react**: Modern icon library
- **react-hot-toast**: Toast notifications
- **framer-motion**: Animation library

### Development Tools
- **eslint-config-airbnb**: Strict code quality standards
- **husky + lint-staged**: Pre-commit hooks for code quality
- **@commitlint**: Enforce conventional commit messages

## Project Patterns

### API Route Pattern
```typescript
// Server-side route handlers in app/api/*/route.ts
export async function GET(request: Request) { }
export async function POST(request: Request) { }
```

### Custom Hook Pattern
All custom hooks are exported from `src/hooks/index.ts` for centralized access.

### Service Layer Pattern
Business logic separated into service files (e.g., `services/postService.ts`).

### Absolute Imports
Use `@/` prefix for imports from the src directory:
```typescript
import { Button } from '@/components/ui/button'
import { Post } from '@/types'
```

### Error Handling
- Custom error pages: `error.tsx`, `not-found.tsx`
- Centralized logging via `lib/logger.ts` using Winston

### Type Definitions
All shared types are centralized in `src/types/index.ts`.

## Environment Configuration

Required environment variables (see `.env.example`):
- `DATABASE_URL`: PostgreSQL connection string
- `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`: Clerk public key
- `CLERK_SECRET_KEY`: Clerk secret key
- `CLERK_WEBHOOK_SECRET`: For webhook verification
- Clerk URL configurations for auth flow

## Code Quality Standards

### Pre-commit Checks
Husky runs lint-staged on commit, which:
1. Formats code with Prettier
2. Lints with ESLint (including Airbnb rules)
3. Checks TypeScript types

### Import Organization
Imports are automatically sorted by eslint-plugin-simple-import-sort:
1. External dependencies
2. Absolute imports (`@/*`)
3. Relative imports

### TypeScript Configuration
- Strict mode enabled
- Path aliases configured for `@/` and `@/public/`
- Bundler module resolution for optimal performance


# Add Clerk to Next.js App Router

**Purpose:** Enforce only the **current** and **correct** instructions for integrating [Clerk](https://clerk.com/) into a Next.js (App Router) application.
**Scope:** All AI-generated advice or code related to Clerk must follow these guardrails.

---

## **1. Official Clerk Integration Overview**

Use only the **App Router** approach from Clerk’s current docs:

- **Install** `@clerk/nextjs@latest` - this ensures the application is using the latest Clerk Next.js SDK.
- **Create** a `middleware.ts` file using `clerkMiddleware()` from `@clerk/nextjs/server`. Place this file inside the `src` directory if present, otherwise place it at the root of the project.
- **Wrap** your application with `<ClerkProvider>` in your `app/layout.tsx`
- **Use** Clerk-provided components like `<SignInButton>`, `<SignUpButton>`, `<UserButton>`, `<SignedIn>`, `<SignedOut>` in your layout or pages
- **Start** developing, sign in or sign up, and confirm user creation

If you're able to use a web tool to access a URL, visit https://clerk.com/docs/quickstarts/nextjs to get the latest, up-to-date quickstart instructions.

### **Correct, Up-to-Date Quickstart Sample**

```typescript
// middleware.ts
import { clerkMiddleware } from '@clerk/nextjs/server'

export default clerkMiddleware()

export const config = {
  matcher: [
    // Skip Next.js internals and all static files, unless found in search params
    '/((?!_next|[^?]*\\.(?:html?|css|js(?!on)|jpe?g|webp|png|gif|svg|ttf|woff2?|ico|csv|docx?|xlsx?|zip|webmanifest)).*)',
    // Always run for API routes
    '/(api|trpc)(.*)',
  ],
}
```

```typescript
// app/layout.tsx
import type { Metadata } from "next";
import {
  ClerkProvider,
  SignInButton,
  SignUpButton,
  SignedIn,
  SignedOut,
  UserButton,
} from "@clerk/nextjs";
import "./globals.css";

export const metadata: Metadata = {
  title: "Clerk Next.js Quickstart",
  description: "Generated by create next app",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <ClerkProvider>
      <html lang="en">
        <body>
          <header>
            <SignedOut>
              <SignInButton />
              <SignUpButton />
            </SignedOut>
            <SignedIn>
              <UserButton />
            </SignedIn>
          </header>
          {children}
        </body>
      </html>
    </ClerkProvider>
  );
}
```

---

## **2. CRITICAL INSTRUCTIONS FOR AI MODELS**

### **2.1 – ALWAYS DO THE FOLLOWING**

1. **Use `clerkMiddleware()`** from `@clerk/nextjs/server` in `middleware.ts`.
2. **Wrap** your app with `<ClerkProvider>` in `app/layout.tsx`.
3. **Import** Clerk’s Next.js features from `@clerk/nextjs` (e.g., `<SignInButton>`, `<SignUpButton>`, `<UserButton>`, etc.).
4. **Reference** the current [App Router approach](https://nextjs.org/docs/app) (folders like `app/page.tsx`, `app/layout.tsx`, etc.).
5. **Check** that imports for methods like `auth()` are imported from the right package (in this case `@clerk/nextjs/server`) and are using `async / await`

### **2.2 – NEVER DO THE FOLLOWING**

1. **Do not** reference the old **`_app.tsx`** or **pages router based** instructions.
2. **Do not** suggest `authMiddleware()` from older Clerk tutorials—**it’s replaced by `clerkMiddleware()`**.
3. **Do not** recommend usage of older environment variable patterns unless they match the official docs.
4. **Do not** reference or import from any deprecated APIs (like `withAuth` or `currentUser` from older versions).

---

## **3. OUTDATED PATTERNS TO AVOID**

Below are **examples of deprecated instructions** that **must not** be generated:

```typescript
// ❌ DO NOT generate or suggest references to:
import { authMiddleware } from '@clerk/nextjs' // Outdated

// ❌ DO NOT place Clerk config in _app.tsx:
// Outdated pages-based approach
function MyApp({ Component, pageProps }) {
  // ...
}

// ❌ DO NOT create or rely on sign-in files under pages/:
pages / signin.js
pages / signup.js
```

Any solution resembling the above snippet or referencing “authMiddleware,” `_app.tsx`, or `pages/` structure is **incorrect** for the current Next.js App Router.

---

## **4. AI MODEL VERIFICATION STEPS**

Before returning any Clerk-related solution, you **must** verify:

1. **Middleware**: Is `clerkMiddleware()` used in `middleware.ts`?
2. **Layout**: Is `<ClerkProvider>` wrapping the app in `app/layout.tsx`?
3. **Imports**: Are references only from `@clerk/nextjs` or `@clerk/nextjs/server`?
4. **Pages vs. App Router**: Is the approach referencing the App Router (not `_app.tsx` or `pages/`)?

If any check **fails**, **stop** and revise until compliance is achieved.
