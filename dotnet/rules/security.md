# .NET Security Standards

## JWT Configuration

- **Algorithm:** HS256
- **Access Token TTL:** 15 dakika
- **Refresh Token TTL:** 7 gun
- **Secret:** Environment variable'dan okunmali (`JWT_SECRET`)

```csharp
// ✅ Good: Secret from environment
var secret = _configuration["Jwt:Secret"];

// ❌ Bad: Hardcoded secret
var secret = "hardcoded-secret-key";
```

## Password Hashing

- **Algorithm:** BCrypt
- **Work Factor:** 12

```csharp
// Always use BCrypt with work factor 12
var hash = _passwordHasher.Hash(password);
var isValid = _passwordHasher.Verify(password, hash);
```

### Password Policy

- Minimum 8 karakter
- En az 1 buyuk harf
- En az 1 kucuk harf
- En az 1 rakam
- En az 1 ozel karakter (@$!%*?&#)

## Input Validation

Her Command icin FluentValidation kullan:

```csharp
public class RegisterCommandValidator : AbstractValidator<RegisterCommand>
{
    public RegisterCommandValidator()
    {
        RuleFor(x => x.Email)
            .NotEmpty()
            .EmailAddress()
            .MaximumLength(255);

        RuleFor(x => x.Password)
            .NotEmpty()
            .MinimumLength(8)
            .Matches(@"[A-Z]").WithMessage("Must contain uppercase")
            .Matches(@"[a-z]").WithMessage("Must contain lowercase")
            .Matches(@"\d").WithMessage("Must contain digit");
    }
}
```

## SQL Injection Prevention

```csharp
// ✅ Good: Parameterized queries (EF Core does this automatically)
var user = await _context.Users
    .FirstOrDefaultAsync(u => u.Email == email);

// ❌ Bad: Raw SQL with string interpolation
var user = await _context.Users
    .FromSqlRaw($"SELECT * FROM Users WHERE Email = '{email}'")
    .FirstOrDefaultAsync();
```

## Sensitive Data Logging

```csharp
// ✅ Good
_logger.LogInformation("User {UserId} logged in", user.Id);

// ❌ Bad
_logger.LogInformation("User logged in with password {Password}", password);
_logger.LogInformation("JWT token: {Token}", token);
```

## Rate Limiting

```csharp
// Login endpoint: 5 requests per minute
// Register endpoint: 3 requests per minute
// General API: 60 requests per minute
```

## Account Lockout

- Max failed attempts: 5
- Lockout duration: 15 minutes
- Tracking: `FailedLoginAttempts` field on User entity
