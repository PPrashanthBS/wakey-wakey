# Security Advisory

## Known Vulnerabilities

### Next.js Authorization Bypass (GHSA-XXXX)

**Severity:** Critical  
**Affected Version:** 15.2.2 (currently in use)  
**Fixed Version:** 15.2.3  
**Status:** Pre-existing (not introduced by setup changes)

#### Description
Authorization Bypass in Next.js Middleware affects Next.js versions 15.0.0 to 15.2.2.

#### Recommendation
**Immediate Action Required:** Upgrade Next.js to version 15.2.3 or later.

```bash
cd apps/web
npm install next@15.2.3
```

Then test the application to ensure compatibility.

#### References
- https://github.com/advisories/GHSA-XXXX (check GitHub Security Advisories)
- https://nextjs.org/blog/security

---

## Security Best Practices

### 1. Environment Variables
- **Never commit `.env` files** to version control
- Store sensitive credentials securely (use secret managers in production)
- Rotate API keys and passwords regularly

### 2. Database Security
- Use strong passwords for database users
- Restrict database access to specific IPs
- Enable SSL/TLS for database connections in production
- Regularly backup your database

### 3. API Security
- Keep JWT public keys secure
- Implement rate limiting on API endpoints
- Validate all user inputs
- Use HTTPS in production

### 4. Solana Wallet Security
- Store private keys securely (use hardware wallets for production)
- Never share or commit private keys
- Use testnet/devnet for development
- Keep minimal funds in hot wallets

### 5. Email Security
- Use app-specific passwords, not account passwords
- Enable 2FA on all service accounts
- Monitor for suspicious email activity
- Consider using email service providers (SendGrid, Mailgun) for production

### 6. Dependency Management
- Regularly run `npm audit` to check for vulnerabilities
- Keep dependencies up to date
- Review dependency changes before updating
- Use `npm audit fix` to automatically fix vulnerabilities when safe

### 7. Production Deployment
- Use environment-specific configuration
- Enable CORS only for trusted domains
- Implement proper logging and monitoring
- Use reverse proxies (nginx) for web servers
- Keep production keys separate from development keys

---

## Security Checklist Before Production

- [ ] Update Next.js to latest stable version (15.2.3+)
- [ ] Run `npm audit` and fix all high/critical vulnerabilities
- [ ] Use strong, unique passwords for all services
- [ ] Enable 2FA on all accounts (Clerk, hosting, database)
- [ ] Configure HTTPS/SSL certificates
- [ ] Set up proper CORS policies
- [ ] Implement rate limiting
- [ ] Configure proper logging and monitoring
- [ ] Review and secure all API endpoints
- [ ] Use production-grade secret management
- [ ] Set up automated backups
- [ ] Configure firewall rules
- [ ] Document incident response procedures

---

## Reporting Security Issues

If you discover a security vulnerability, please report it by:
1. **DO NOT** create a public GitHub issue
2. Email the maintainers directly (check SECURITY.md if available)
3. Provide detailed information about the vulnerability
4. Allow time for the issue to be addressed before public disclosure

---

Last Updated: 2025-11-14
