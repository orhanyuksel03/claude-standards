# Generic Security Standards

## Tum Projeler Icin Gecerli

### Hassas Veri Yonetimi

- Hassas verileri asla hard-code etme (API keys, passwords, tokens)
- Environment variables kullan (`.env` dosyasi)
- `.gitignore`'a hassas dosyalari ekle (`.env`, `secrets.json`, `credentials.yml`)
- Production ortaminda secret management kullan (Azure Key Vault, AWS Secrets Manager vb.)

### Input Validation

- Tum kullanici girdilerini dogrula
- XSS, SQL Injection, Command Injection'a karsi koruma
- Maximum length kontrolleri uygula
- Whitelist yaklasimi kullan (blacklist yerine)

### Network Security

- HTTPS kullan (production'da zorunlu)
- Rate limiting uygula (API endpoint'leri icin)
- CORS ayarlarini dogru yap (wildcard `*` kullanma production'da)

### Authentication & Authorization

- Password'lari hashle (BCrypt, Argon2, PBKDF2)
- JWT token'lari guvenli sakla
- Role-based access control (RBAC) uygula
- Session timeout ayarla

### Logging Security

```text
✅ Good: User {UserId} logged in
✅ Good: Failed login attempt for user {UserId}

❌ Bad: User logged in with password {Password}
❌ Bad: JWT token: {Token}
❌ Bad: API key: {ApiKey}
```

### Dependency Security

- Third-party library'leri duzenli guncelle
- Bilinen vulnerability'leri tara (`npm audit`, `dotnet list package --vulnerable`)
- Minimum privilege prensibi uygula
