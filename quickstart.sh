#!/bin/bash

# Wakey-Wakey Quick Start Script
# This script helps you get started with the project quickly

echo "🚀 Wakey-Wakey Quick Start"
echo "=========================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if npm is installed
if ! command -v npm &> /dev/null; then
    echo -e "${RED}❌ npm is not installed. Please install Node.js first.${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Node.js and npm are installed${NC}"
echo ""

# Check if dependencies are installed
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
    if [ $? -ne 0 ]; then
        echo -e "${RED}❌ Failed to install dependencies${NC}"
        exit 1
    fi
    echo -e "${GREEN}✓ Dependencies installed${NC}"
else
    echo -e "${GREEN}✓ Dependencies already installed${NC}"
fi
echo ""

# Check if .env files exist
echo "🔐 Checking environment configuration..."
MISSING_ENV=0

if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠  Root .env file not found. Creating from .env.example...${NC}"
    cp .env.example .env
    MISSING_ENV=1
fi

if [ ! -f "apps/api/.env" ]; then
    echo -e "${YELLOW}⚠  API .env file not found. Creating from .env.example...${NC}"
    cp apps/api/.env.example apps/api/.env
    MISSING_ENV=1
fi

if [ ! -f "apps/hub/.env" ]; then
    echo -e "${YELLOW}⚠  Hub .env file not found. Creating from .env.example...${NC}"
    cp apps/hub/.env.example apps/hub/.env
    MISSING_ENV=1
fi

if [ ! -f "apps/web/.env" ]; then
    echo -e "${YELLOW}⚠  Web .env file not found. Creating from .env.example...${NC}"
    cp apps/web/.env.example apps/web/.env
    MISSING_ENV=1
fi

if [ $MISSING_ENV -eq 1 ]; then
    echo ""
    echo -e "${YELLOW}⚠  IMPORTANT: Please update the .env files with your actual credentials${NC}"
    echo "   See SETUP.md for detailed instructions on getting required keys"
    echo ""
    read -p "Press Enter to continue after updating .env files..."
fi

echo -e "${GREEN}✓ Environment files configured${NC}"
echo ""

# Generate Prisma client
echo "🔧 Generating Prisma client..."
cd packages/db
npx prisma generate > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Failed to generate Prisma client${NC}"
    exit 1
fi
cd ../..
echo -e "${GREEN}✓ Prisma client generated${NC}"
echo ""

echo "════════════════════════════════════════"
echo -e "${GREEN}✅ Setup complete!${NC}"
echo "════════════════════════════════════════"
echo ""
echo "Next steps:"
echo ""
echo "1. Configure your PostgreSQL database"
echo "   - Create database: wakey_wakey"
echo "   - Update DATABASE_URL in .env files"
echo ""
echo "2. Run database migrations:"
echo "   cd packages/db"
echo "   npx prisma migrate dev --name init"
echo "   cd ../.."
echo ""
echo "3. Start the development servers:"
echo ""
echo "   Option A - All services (recommended):"
echo "   npm run dev"
echo ""
echo "   Option B - Individual services:"
echo "   # Terminal 1 - API Server"
echo "   cd apps/api && npm run dev"
echo ""
echo "   # Terminal 2 - Hub Server"
echo "   cd apps/hub && npm run dev"
echo ""
echo "   # Terminal 3 - Web App"
echo "   cd apps/web && npm run dev"
echo ""
echo "4. Open your browser:"
echo "   - Web App: http://localhost:3000"
echo "   - API: http://localhost:5555"
echo ""
echo "For detailed setup instructions, see SETUP.md"
echo ""
