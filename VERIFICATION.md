# Installation Verification Guide

This document helps you verify that Wakey-Wakey is properly installed and configured.

## Quick Verification Checklist

### ✅ Prerequisites Installed
- [ ] Node.js v18+ is installed (`node --version`)
- [ ] npm is installed (`npm --version`)
- [ ] PostgreSQL is installed and running (`psql --version`)
- [ ] (Optional) Bun v1.2.4+ is installed (`bun --version`)

### ✅ Project Setup
- [ ] Repository cloned
- [ ] Dependencies installed (`node_modules` folder exists)
- [ ] Prisma client generated

### ✅ Configuration Files
- [ ] `.env` exists at root level
- [ ] `apps/api/.env` exists
- [ ] `apps/hub/.env` exists
- [ ] `apps/web/.env` exists

### ✅ Database Configuration
- [ ] PostgreSQL database created (default: `wakey_wakey`)
- [ ] `DATABASE_URL` is set correctly in all `.env` files
- [ ] Database migrations have been run

### ✅ External Services Configuration
- [ ] Clerk account created and keys configured
- [ ] Solana wallet created and funded (for validators)
- [ ] Gmail app password configured (for email alerts)

## Detailed Verification Steps

### 1. Verify Dependencies Installation

Run the following command in the project root:

```bash
npm list --depth=0
```

Expected output should show all main dependencies without errors.

### 2. Verify Prisma Client

```bash
cd packages/db
npx prisma validate
```

Expected output: "✔ The schema is valid."

### 3. Test Database Connection

```bash
cd packages/db
npx prisma db push --skip-generate
```

If successful, your database schema is synchronized.

Alternatively, open Prisma Studio to view your database:
```bash
npx prisma studio
```

### 4. Verify Environment Variables

Check that all required environment variables are set:

#### Root `.env`
```bash
cat .env | grep -v '^#' | grep -v '^$'
```

Should show: `DATABASE_URL`

#### API `.env`
```bash
cat apps/api/.env | grep -v '^#' | grep -v '^$'
```

Should show: `PORT`, `JWT_PUBLIC_KEY`, `CONNECTION_URL`, `SECRET_KEY`, `DATABASE_URL`

#### Hub `.env`
```bash
cat apps/hub/.env | grep -v '^#' | grep -v '^$'
```

Should show: `WS_PORT`, `MAIL_PASS`, `DATABASE_URL`

#### Web `.env`
```bash
cat apps/web/.env | grep -v '^#' | grep -v '^$'
```

Should show: `NEXT_PUBLIC_API_URL`, Clerk keys

### 5. Test Individual App Builds

Test if each app can build successfully:

#### Test API Build
```bash
cd apps/api
npm run build
```

Expected: Build completes without errors

#### Test Hub Build
```bash
cd apps/hub
npm run build
```

Expected: Build completes without errors

#### Test Web Build
```bash
cd apps/web
npm run build
```

Expected: Build completes without errors (might show warnings about environment variables if not configured)

### 6. Test Individual App Starts

Try starting each app individually:

#### Start API Server
```bash
cd apps/api
npm run dev
```

Expected output:
- "Server is running on port 5555" (or your configured PORT)
- No error messages about missing environment variables

Access http://localhost:5555 - should see "Api is alive"

Press Ctrl+C to stop.

#### Start Hub Server
```bash
cd apps/hub
npm run dev
```

Expected output:
- WebSocket server starts
- No database connection errors

Press Ctrl+C to stop.

#### Start Web App
```bash
cd apps/web
npm run dev
```

Expected output:
- Next.js compilation succeeds
- Server starts on http://localhost:3000
- No critical errors in console

Open http://localhost:3000 in browser - app should load (might show login screen).

Press Ctrl+C to stop.

## Common Issues and Solutions

### Issue: "Cannot find module '@prisma/client'"

**Solution:**
```bash
cd packages/db
npx prisma generate
```

### Issue: "Port already in use"

**Solution:**
Find and kill the process using the port:
```bash
# For API (port 5555)
lsof -ti:5555 | xargs kill -9

# For Hub (port 5050)
lsof -ti:5050 | xargs kill -9

# For Web (port 3000)
lsof -ti:3000 | xargs kill -9
```

### Issue: Database connection error

**Solution:**
1. Verify PostgreSQL is running:
   ```bash
   pg_isready
   ```

2. Check DATABASE_URL format:
   ```
   postgresql://username:password@localhost:5432/database_name
   ```

3. Test connection manually:
   ```bash
   psql -U username -d database_name
   ```

### Issue: "JWT verification failed"

**Solution:**
1. Verify your Clerk JWT public key is correct
2. Ensure the public key includes the BEGIN and END markers
3. Format should be: `-----BEGIN PUBLIC KEY-----\n...\n-----END PUBLIC KEY-----`

### Issue: Build fails with TypeScript errors

**Solution:**
```bash
# Clean node_modules and reinstall
rm -rf node_modules package-lock.json
npm install

# Regenerate Prisma client
cd packages/db
npx prisma generate
cd ../..
```

## Success Indicators

✅ **Installation is successful when:**
- All dependencies are installed without errors
- Prisma client is generated
- Database connection works
- All environment files are configured
- At least one app can start successfully

✅ **System is ready for development when:**
- All three apps (API, Hub, Web) can start simultaneously
- Web app loads in browser
- API responds to requests
- Hub connects to WebSocket clients
- Database is accessible from all apps

## Next Steps

Once verification is complete:

1. **For Website Owners:**
   - Sign up through the web interface
   - Add your website for monitoring
   - Configure alert preferences

2. **For Validators:**
   - Set up your Solana wallet
   - Register as a validator
   - Start monitoring websites and earning rewards

3. **For Developers:**
   - Review the codebase structure
   - Check out CONTRIBUTING.md for development guidelines
   - Start making your contributions!

## Getting Help

If you encounter issues not covered here:

1. Check [SETUP.md](SETUP.md) for detailed setup instructions
2. Review [README.md](README.md) for project overview
3. Search existing GitHub Issues
4. Create a new issue with:
   - Your operating system
   - Node.js and npm versions
   - Error messages (full output)
   - Steps to reproduce

---

Happy monitoring! 🚀
