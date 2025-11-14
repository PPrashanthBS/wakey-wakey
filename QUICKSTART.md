# Complete Local Setup - Quick Reference

This is a quick reference guide to get Wakey-Wakey running on your local machine. For detailed instructions, see [SETUP.md](SETUP.md).

## 🚀 Quick Start (5 minutes)

### 1. Install Prerequisites
```bash
# Check Node.js (need v18+)
node --version

# Check PostgreSQL
psql --version

# Optional: Install Bun
curl -fsSL https://bun.sh/install | bash
```

### 2. Clone and Install
```bash
git clone https://github.com/PPrashanthBS/wakey-wakey.git
cd wakey-wakey
npm install  # or: bun install
```

### 3. Configure Environment
```bash
# Run the quick start script
./quickstart.sh

# Or manually copy templates
cp .env.example .env
cp apps/api/.env.example apps/api/.env
cp apps/hub/.env.example apps/hub/.env
cp apps/web/.env.example apps/web/.env
```

**Edit each `.env` file with your credentials** (see below for required keys).

### 4. Set Up Database
```bash
# Create PostgreSQL database
createdb wakey_wakey

# Update DATABASE_URL in all .env files
# Format: postgresql://username:password@localhost:5432/wakey_wakey

# Run migrations
cd packages/db
npx prisma migrate dev --name init
npx prisma generate
cd ../..
```

### 5. Start Development Servers
```bash
npm run dev
# or: bun run dev
```

Access:
- **Web App**: http://localhost:3000
- **API**: http://localhost:5555
- **Hub**: WebSocket on port 5050

---

## 📋 Required Environment Variables

### Root `.env`
```bash
DATABASE_URL="postgresql://user:password@localhost:5432/wakey_wakey"
```

### API `apps/api/.env`
```bash
PORT=5555
DATABASE_URL="postgresql://user:password@localhost:5432/wakey_wakey"
JWT_PUBLIC_KEY="your-clerk-jwt-public-key"
CONNECTION_URL="https://api.devnet.solana.com"
SECRET_KEY="your-solana-wallet-secret-key"
```

### Hub `apps/hub/.env`
```bash
WS_PORT=5050
DATABASE_URL="postgresql://user:password@localhost:5432/wakey_wakey"
MAIL_PASS="your-gmail-app-password"
```

### Web `apps/web/.env`
```bash
NEXT_PUBLIC_API_URL="http://localhost:5555"
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY="your-clerk-publishable-key"
CLERK_SECRET_KEY="your-clerk-secret-key"
NEXT_PUBLIC_CLERK_SIGN_IN_URL="/sign-in"
NEXT_PUBLIC_CLERK_SIGN_UP_URL="/sign-up"
```

---

## 🔑 Getting API Keys

### Clerk (Authentication)
1. Sign up at https://clerk.com
2. Create a new application
3. Copy publishable and secret keys
4. For JWT: **JWT Templates** → Create/Select → Copy public key

### Solana Wallet
```bash
# Install Solana CLI
sh -c "$(curl -sSfL https://release.solana.com/stable/install)"

# Generate keypair
solana-keygen new

# Get secret key (base58)
solana-keygen export ~/path/to/keypair.json --outfile - | base58

# Fund devnet wallet (for testing)
solana airdrop 2 YOUR_PUBLIC_KEY --url https://api.devnet.solana.com
```

### Gmail (Email Alerts)
1. Enable 2FA on Google account
2. Visit: https://myaccount.google.com/apppasswords
3. Generate app password for "Mail"
4. Use in `MAIL_PASS` variable

---

## 🎯 Project Structure

```
wakey-wakey/
├── apps/
│   ├── api/          # Express API server (port 5555)
│   ├── hub/          # WebSocket coordinator (port 5050)
│   └── web/          # Next.js frontend (port 3000)
├── packages/
│   ├── db/           # Prisma database client
│   ├── common/       # Shared utilities
│   └── ui/           # React components
├── .env.example      # Environment templates
└── SETUP.md         # Detailed setup guide
```

---

## 🛠️ Common Commands

```bash
# Install dependencies
npm install

# Generate Prisma client
cd packages/db && npx prisma generate

# Run database migrations
cd packages/db && npx prisma migrate dev

# View database (Prisma Studio)
cd packages/db && npx prisma studio

# Start all apps
npm run dev

# Build all apps
npm run build

# Lint code
npm run lint

# Format code
npm run format
```

---

## 🔍 Verification

### Test Installation
```bash
# Verify Prisma
cd packages/db && npx prisma validate

# Test API
curl http://localhost:5555
# Should return: "Api is alive"

# Test Web
open http://localhost:3000
```

### Run Individual Apps
```bash
# API only
cd apps/api && npm run dev

# Hub only
cd apps/hub && npm run dev

# Web only
cd apps/web && npm run dev
```

---

## 🐛 Troubleshooting

### Port in Use
```bash
# Kill process on port
lsof -ti:5555 | xargs kill -9  # API
lsof -ti:5050 | xargs kill -9  # Hub
lsof -ti:3000 | xargs kill -9  # Web
```

### Database Connection Error
```bash
# Check PostgreSQL is running
pg_isready

# Test connection
psql -U username -d wakey_wakey
```

### Prisma Issues
```bash
cd packages/db
npx prisma generate
npx prisma migrate reset
```

### Module Not Found
```bash
# Clean reinstall
rm -rf node_modules package-lock.json
npm install
```

---

## 📚 Documentation

- **[SETUP.md](SETUP.md)** - Complete setup guide
- **[VERIFICATION.md](VERIFICATION.md)** - Installation verification
- **[SECURITY.md](SECURITY.md)** - Security best practices
- **[README.md](README.md)** - Project overview

---

## ⚠️ Important Notes

1. **Security**: Never commit `.env` files
2. **Next.js**: Current version (15.2.2) has a known vulnerability. Upgrade to 15.2.3+ for production
3. **Testing**: Use devnet for Solana (not mainnet)
4. **Production**: See SECURITY.md checklist before deploying

---

## ✅ Success Checklist

- [ ] All prerequisites installed
- [ ] Dependencies installed (`node_modules` exists)
- [ ] All `.env` files configured
- [ ] Database created and migrated
- [ ] Prisma client generated
- [ ] All apps start without errors
- [ ] Web app loads at http://localhost:3000
- [ ] API responds at http://localhost:5555

---

## 🆘 Need Help?

1. Check [SETUP.md](SETUP.md) for detailed instructions
2. Review [VERIFICATION.md](VERIFICATION.md) for verification steps
3. Search GitHub Issues
4. Create new issue with error details

---

**Ready to monitor websites? Start all services with `npm run dev`** 🚀
