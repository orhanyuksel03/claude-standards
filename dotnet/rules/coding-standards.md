# C# Coding Standards

## Naming Conventions

### PascalCase

- Classes, records, structs
- Interfaces (`I` prefix): `IUserRepository`
- Methods, properties
- Enums and enum values

### camelCase + _ prefix

- Private fields: `_userRepository`, `_cachedValue`
- Local variables: `var processedName`
- Method parameters: `string userName`

### SCREAMING_SNAKE_CASE

- Constants only: `MAX_RETRY_COUNT`, `DEFAULT_CULTURE`

### Naming Patterns

- DTOs: `{Name}Dto` (UserDto, EventDto)
- Commands: `{Action}Command` (RegisterCommand)
- Queries: `{Action}Query` (GetUserByIdQuery)
- Handlers: `{Command/Query}Handler` (RegisterCommandHandler)
- Validators: `{Command/Query}Validator` (RegisterCommandValidator)

---

## Modern C# Features

### Records for DTOs

```csharp
// ✅ Good: Immutable DTOs
public record UserDto(Guid Id, string FirstName, string LastName, string Email);

public record RegisterCommand : IRequest<Result<AuthResponseDto>>
{
    public string FirstName { get; init; } = string.Empty;
    public string Email { get; init; } = string.Empty;
}

// ❌ Bad: Mutable DTOs
public class UserDto
{
    public Guid Id { get; set; }
    public string FirstName { get; set; }
}
```

### Primary Constructors (C# 12)

```csharp
public class UserService(IUserRepository repository, ILogger<UserService> logger)
{
    public async Task<User?> GetUserAsync(Guid id)
    {
        logger.LogInformation("Getting user {UserId}", id);
        return await repository.GetByIdAsync(id);
    }
}
```

### Pattern Matching

```csharp
return result.Match(
    onSuccess: value => Ok(value),
    onFailure: error => error.Type switch
    {
        ErrorType.NotFound => NotFound(error),
        ErrorType.Validation => BadRequest(error),
        ErrorType.Unauthorized => Unauthorized(error),
        _ => StatusCode(500, error)
    }
);
```

### Null Reference Types

```csharp
public string FirstName { get; set; } = string.Empty;  // Non-nullable
public string? PhoneNumber { get; set; }               // Nullable

public async Task<User?> GetByIdAsync(Guid id);        // May return null
```

### File-Scoped Namespaces

```csharp
namespace AuthService.Application.Features.Auth.Commands.Register;

public record RegisterCommand : IRequest<Result<AuthResponseDto>>
{
    // ...
}
```

---

## Using Directives Order

1. System namespaces
2. External libraries
3. Project namespaces
4. Alphabetically sorted

```csharp
using System;
using System.Threading.Tasks;

using MediatR;
using FluentValidation;

using AuthService.Domain.Entities;
using AuthService.Application.Common.Interfaces;
```

---

## Async/Await

### Always Async All the Way

```csharp
// ✅ Good
public async Task<User?> GetUserAsync(Guid id)
{
    return await _repository.GetByIdAsync(id);
}

// ❌ Bad: Blocking on async
public User? GetUser(Guid id)
{
    return _repository.GetByIdAsync(id).Result;  // NEVER DO THIS
}
```

### CancellationToken

```csharp
// ✅ Always accept and pass CancellationToken
public async Task<Result<UserDto>> Handle(
    GetUserByIdQuery request,
    CancellationToken cancellationToken)
{
    var user = await _repository.GetByIdAsync(request.UserId, cancellationToken);
}
```

---

## Error Handling - Result Pattern

```csharp
// ✅ Good: Result pattern for business logic
public async Task<Result<User>> RegisterUserAsync(string email)
{
    var existingUser = await _repository.GetByEmailAsync(email);
    if (existingUser != null)
        return Result<User>.Failure(Error.Conflict("Email already registered"));

    return Result<User>.Success(user);
}

// ❌ Bad: Exceptions for business logic
public async Task<User> RegisterUserAsync(string email)
{
    if (existingUser != null)
        throw new EmailAlreadyExistsException();  // Flow control icin exception kullanma
}
```

Exceptions sadece gercekten exceptional durumlar icin:

```csharp
if (amount < 0)
    throw new ArgumentException("Amount cannot be negative", nameof(amount));
```

---

## Dependency Injection

### Constructor Injection

```csharp
// ✅ Good
public class UserService
{
    private readonly IUserRepository _repository;
    private readonly ILogger<UserService> _logger;

    public UserService(IUserRepository repository, ILogger<UserService> logger)
    {
        _repository = repository ?? throw new ArgumentNullException(nameof(repository));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }
}

// ❌ Bad: Service locator
public class UserService
{
    public UserService(IServiceProvider serviceProvider)
    {
        _repository = serviceProvider.GetRequiredService<IUserRepository>();
    }
}
```

### Interface Segregation

```csharp
// ✅ Good: Small, focused interfaces
public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id, CancellationToken ct = default);
    Task<User?> GetByEmailAsync(string email, CancellationToken ct = default);
}

// ❌ Bad: God interface with 20+ methods
```

---

## LINQ Best Practices

```csharp
// ✅ Good: Readable, chained
var activeUsers = await _context.Users
    .Where(u => u.Status == UserStatus.Active)
    .Where(u => u.EmailVerified)
    .OrderByDescending(u => u.CreatedAt)
    .Take(10)
    .ToListAsync(cancellationToken);

// ❌ Bad: Single long line
var users = _context.Users.Where(u => u.Status == UserStatus.Active && u.EmailVerified).OrderByDescending(u => u.CreatedAt).Take(10).ToListAsync();
```

Avoid multiple enumerations - materialize with `ToList()` first.

---

## Performance

### String Concatenation

```csharp
// ✅ StringBuilder for loops
var sb = new StringBuilder();
foreach (var user in users)
    sb.AppendLine($"{user.FirstName} {user.LastName}");

// ✅ String interpolation for simple cases
var fullName = $"{user.FirstName} {user.LastName}";

// ❌ String concatenation in loops
var result = "";
foreach (var user in users)
    result += $"{user.FirstName}\n";  // Creates new string each iteration
```

### Collections

```csharp
// ✅ Pre-size if count known
var users = new List<User>(capacity: 100);

// ✅ Collection expressions (C# 12)
List<int> numbers = [1, 2, 3, 4, 5];
```

---

## Comments

```csharp
// ✅ Good: Comment explains WHY
// Lock account after 5 failed attempts to prevent brute force attacks
if (user.FailedLoginAttempts >= 5)
    user.LockUntil = DateTime.UtcNow.AddMinutes(15);

// ❌ Bad: Comment explains WHAT (code already shows)
// Increment failed login attempts by one
user.FailedLoginAttempts++;

// ❌ Bad: Commented-out code (use git history)
// var oldEmail = user.Email;
```

XML documentation for public APIs only.

---

## Code Analysis

```xml
<!-- In .csproj -->
<PropertyGroup>
    <Nullable>enable</Nullable>
    <TreatWarningsAsErrors>true</TreatWarningsAsErrors>
</PropertyGroup>

<ItemGroup>
    <PackageReference Include="StyleCop.Analyzers" Version="1.2.0-beta.435" />
    <PackageReference Include="Microsoft.CodeAnalysis.NetAnalyzers" Version="8.0.0" />
</ItemGroup>
```
