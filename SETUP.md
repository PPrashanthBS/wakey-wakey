# Wakey-Wakey Local Setup Guide

This guide will help you set up and run the Wakey-Wakey project locally on your machine.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
- [Running the Project](#running-the-project)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)

## Prerequisites

Before you begin, ensure you have the following installed on your system:

### Required Software

1. **Node.js** (v18 or higher)
   - Download from: https://nodejs.org/
   - Verify installation: `node --version`

2. **Bun** (v1.2.4 or higher) - Recommended
   - Install with: `curl -fsSL https://bun.sh/install | bash`
   - Verify installation: `bun --version`
   - **Alternative**: You can use npm if Bun is not available

3. **PostgreSQL** (v12 or higher)
   - Download from: https://www.postgresql.org/download/
   - Verify installation: `psql --version`

### Optional but Recommended

- **Git** for version control
- **VS Code** or your preferred IDE
- **Postman** or similar tool for API testing

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/PPrashanthBS/wakey-wakey.git
cd wakey-wakey
```

### Step 2: Install Dependencies

#### Using Bun (Recommended)
```bash
bun install
```

#### Using npm (Alternative)
```bash
npm install
```

### Step 3: Generate Prisma Client

```bash
cd packages/db
npx prisma generate
cd ../..
```

## Configuration

### Environment Variables

The project requires several environment variables to be configured. Copy the example files and fill in your values:

#### 1. Root Level Configuration
```bash
cp .env.example .env
```

Edit `.env` and set:
- `DATABASE_URL`: Your PostgreSQL connection string

#### 2. API Server Configuration
```bash
cp apps/api/.env.example apps/api/.env
```

Edit `apps/api/.env` and set:
- `PORT`: API server port (default: 5555)
- `JWT_PUBLIC_KEY`: Your Clerk JWT public key
- `CONNECTION_URL`: Solana RPC URL (use `https://api.devnet.solana.com` for testing)
- `SECRET_KEY`: Your Solana wallet secret key (base58 encoded)
- `DATABASE_URL`: Your PostgreSQL connection string

#### 3. Hub Server Configuration
```bash
cp apps/hub/.env.example apps/hub/.env
```

Edit `apps/hub/.env` and set:
- `WS_PORT`: WebSocket server port (default: 5050)
- `MAIL_PASS`: Gmail app password for email alerts
- `DATABASE_URL`: Your PostgreSQL connection string

#### 4. Web Application Configuration
```bash
cp apps/web/.env.example apps/web/.env
```

Edit `apps/web/.env` and set:
- `NEXT_PUBLIC_API_URL`: API server URL (default: `http://localhost:5555`)
- `NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY`: Your Clerk publishable key
- `CLERK_SECRET_KEY`: Your Clerk secret key

### Getting Required Keys

#### Clerk Authentication Keys
1. Sign up at https://clerk.com/
2. Create a new application
3. Copy the publishable and secret keys from the dashboard
4. For JWT public key: Go to **JWT Templates** → Create/Select template → Copy the public key

#### Solana Wallet Setup
1. Install Solana CLI: https://docs.solana.com/cli/install-solana-cli-tools
2. Generate a keypair: `solana-keygen new`
3. Get the secret key in base58 format:
   ```bash
   solana-keygen export ~/path/to/keypair.json --outfile - | base58
   ```
4. Fund your devnet wallet (for testing):
   ```bash
   solana airdrop 2 YOUR_PUBLIC_KEY --url https://api.devnet.solana.com
   ```

#### Gmail App Password (for email alerts)
1. Enable 2-Factor Authentication on your Google account
2. Go to: https://myaccount.google.com/apppasswords
3. Generate a new app password for "Mail"
4. Use this password in the `MAIL_PASS` environment variable

## Database Setup

### Step 1: Create Database

Connect to PostgreSQL and create a database:

```bash
psql -U postgres
```

```sql
CREATE DATABASE wakey_wakey;
\q
```

### Step 2: Update DATABASE_URL

Update the `DATABASE_URL` in all `.env` files with your actual PostgreSQL credentials:

```
DATABASE_URL="postgresql://username:password@localhost:5432/wakey_wakey"
```

### Step 3: Run Migrations

```bash
cd packages/db
npx prisma migrate dev --name init
cd ../..
```

### Step 4: (Optional) Seed Database

If you want to add sample data, you can create a seed script or manually insert data using Prisma Studio:

```bash
cd packages/db
npx prisma studio
```

This opens a web interface at http://localhost:5555 where you can view and edit your database.

## Running the Project

The project is a monorepo with multiple apps. You can run all apps together or individually.

### Run All Apps (Development Mode)

Using Bun:
```bash
bun run dev
```

Using npm:
```bash
npm run dev
```

This will start:
- **API Server**: http://localhost:5555
- **Hub Server**: WebSocket on port 5050
- **Web App**: http://localhost:3000

### Run Individual Apps

#### API Server Only
```bash
cd apps/api
bun run dev
# or
npm run dev
```

#### Hub Server Only
```bash
cd apps/hub
bun run dev
# or
npm run dev
```

#### Web App Only
```bash
cd apps/web
bun run dev
# or
npm run dev
```

### Build for Production

Build all apps:
```bash
bun run build
# or
npm run build
```

Build individual apps:
```bash
cd apps/[api|hub|web]
bun run build
# or
npm run build
```

## Project Structure

```
wakey-wakey/
├── apps/
│   ├── api/          # Backend API server (Express)
│   ├── hub/          # WebSocket server for validator coordination
│   └── web/          # Next.js frontend application
├── packages/
│   ├── common/       # Shared types and utilities
│   ├── db/           # Prisma database client and schemas
│   ├── ui/           # React component library
│   ├── eslint-config/     # Shared ESLint configuration
│   └── typescript-config/ # Shared TypeScript configuration
├── .env.example      # Root environment variables template
├── package.json      # Root package configuration
├── turbo.json        # Turborepo configuration
└── bun.lock / package-lock.json  # Dependency lock files
```

## Development Workflow

1. **Make changes** to any app or package
2. **Hot reload** is enabled - changes will reflect automatically
3. **Build** to check for errors: `bun run build` or `npm run build`
4. **Lint** your code: `bun run lint` or `npm run lint`
5. **Format** code: `bun run format` or `npm run format`

## Troubleshooting

### Bun Installation Issues

If Bun crashes or doesn't work on your system, use npm instead:
```bash
npm install
npm run dev
```

### Database Connection Issues

- Ensure PostgreSQL is running: `pg_isready`
- Check your DATABASE_URL format
- Verify credentials and database exists
- Check firewall settings if using remote database

### Port Already in Use

If you get "port already in use" errors:
- API (5555): `lsof -ti:5555 | xargs kill -9`
- Hub (5050): `lsof -ti:5050 | xargs kill -9`
- Web (3000): `lsof -ti:3000 | xargs kill -9`

Or change the port in the respective `.env` file.

### Prisma Issues

If you encounter Prisma-related errors:
```bash
cd packages/db
npx prisma generate
npx prisma migrate dev
```

### Module Not Found Errors

Clean and reinstall dependencies:
```bash
rm -rf node_modules bun.lock package-lock.json
bun install
# or
npm install
```

### Clerk Authentication Issues

- Verify your Clerk keys are correct
- Ensure you're using the right environment (development/production)
- Check that Clerk application is configured with correct redirect URLs

### Solana Connection Issues

- Check if Solana devnet is accessible
- Verify your wallet has sufficient funds for transactions
- Try using a different RPC endpoint if needed

## Additional Resources

- **Turborepo Documentation**: https://turbo.build/repo/docs
- **Prisma Documentation**: https://www.prisma.io/docs
- **Next.js Documentation**: https://nextjs.org/docs
- **Clerk Documentation**: https://clerk.com/docs
- **Solana Documentation**: https://docs.solana.com/

## Need Help?

If you encounter issues not covered in this guide:
1. Check the GitHub Issues page
2. Review the README.md for additional context
3. Create a new issue with detailed error messages and steps to reproduce

---

Happy coding! 🚀
