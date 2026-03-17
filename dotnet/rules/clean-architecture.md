# Clean Architecture Rules

## Katman Kurallari

### Domain Layer (Pure Business Logic)

- **Path:** `{ServiceName}.Domain/`
- **Bagimlilik:** HICBIR sey (pure C#)
- **Icerik:**
  - Entities (User, Role, RefreshToken)
  - Value Objects (Email, PasswordHash)
  - Domain Events
  - Enums
  - Domain Exceptions

```csharp
// ✅ Good: Business logic entity icinde
public class User : BaseEntity
{
    public void RecordLoginAttempt(bool success)
    {
        if (success)
        {
            FailedLoginAttempts = 0;
            LockedUntil = null;
        }
        else
        {
            FailedLoginAttempts++;
            if (FailedLoginAttempts >= 5)
                LockedUntil = DateTime.UtcNow.AddMinutes(15);
        }
    }
}

// ❌ Bad: Business logic handler'da
public class LoginHandler
{
    public async Task Handle(...)
    {
        if (success)
            user.FailedLoginAttempts = 0;  // Entity logic'ini bypass ediyor
    }
}
```

### Application Layer (Orchestration)

- **Path:** `{ServiceName}.Application/`
- **Bagimlilik:** Sadece Domain
- **Icerik:**
  - CQRS Commands ve Queries
  - Command/Query Handlers
  - FluentValidation Validators
  - DTOs
  - Repository Interfaces
  - Service Interfaces
  - MediatR Pipeline Behaviors

```csharp
// ✅ Good: Handler orchestrate eder, entity logic'e sahip
public class LoginCommandHandler
{
    public async Task<Result<AuthResponse>> Handle(...)
    {
        var user = await _repository.GetByEmailAsync(request.Email);
        var isValid = _passwordHasher.Verify(request.Password, user.PasswordHash);

        user.RecordLoginAttempt(isValid);  // Entity method
        await _repository.SaveChangesAsync();

        if (isValid)
            return Result<AuthResponse>.Success(...);
        else
            return Result<AuthResponse>.Failure(...);
    }
}
```

### Infrastructure Layer (External Concerns)

- **Path:** `{ServiceName}.Infrastructure/`
- **Bagimlilik:** Application + Domain
- **Icerik:**
  - EF Core DbContext
  - Repository Implementations
  - External Service Implementations (JWT, BCrypt, Redis, RabbitMQ)

### API Layer (Presentation)

- **Path:** `{ServiceName}.API/`
- **Bagimlilik:** Application + Infrastructure
- **Icerik:**
  - Controllers
  - Middleware
  - Program.cs (DI registration)
  - appsettings.json

---

## Class Organization Order

1. Constants
2. Static fields
3. Instance fields
4. Constructors
5. Properties
6. Methods (public → private)
7. Nested types

```csharp
public class User : BaseEntity
{
    // 1. Constants
    private const int MAX_FAILED_ATTEMPTS = 5;

    // 2. Static fields
    private static readonly TimeSpan LockoutDuration = TimeSpan.FromMinutes(15);

    // 3. Instance fields
    private readonly List<IDomainEvent> _domainEvents = new();

    // 4. Constructors
    private User() { }

    // 5. Properties
    public string FirstName { get; private set; }
    public Email Email { get; private set; }

    // 6. Public methods
    public static User Create(string firstName, Email email) { ... }
    public void VerifyEmail() { ... }

    // 7. Private methods
    private void ValidateEmail() { ... }
}
```

## File Organization

- **Bir dosya = bir class**
- Dosya adi = Primary class name
- Klasor yapisi namespace'i yansitir

```text
Application/
  Features/
    Auth/
      Commands/
        Register/
          RegisterCommand.cs
          RegisterCommandHandler.cs
          RegisterCommandValidator.cs
```
