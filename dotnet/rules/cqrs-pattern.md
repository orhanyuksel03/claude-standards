# CQRS Pattern Standards

## Genel Yapi

Her islem icin 3 dosya olustur:

```text
Features/
  {Module}/
    Commands/
      {Action}/
        {Action}Command.cs        → IRequest<Result<TResponse>>
        {Action}CommandHandler.cs  → IRequestHandler
        {Action}CommandValidator.cs → AbstractValidator
    Queries/
      {Action}/
        {Action}Query.cs
        {Action}QueryHandler.cs
```

## Command (Write Operations)

```csharp
public record RegisterCommand : IRequest<Result<AuthResponseDto>>
{
    public string FirstName { get; init; } = string.Empty;
    public string LastName { get; init; } = string.Empty;
    public string Email { get; init; } = string.Empty;
    public string Password { get; init; } = string.Empty;
}
```

## Query (Read Operations)

```csharp
public record GetUserByIdQuery(Guid UserId) : IRequest<Result<UserDto>>;
```

## Handler

```csharp
public class RegisterCommandHandler(
    IUserRepository repository,
    IPasswordHasher passwordHasher,
    ILogger<RegisterCommandHandler> logger)
    : IRequestHandler<RegisterCommand, Result<AuthResponseDto>>
{
    public async Task<Result<AuthResponseDto>> Handle(
        RegisterCommand request,
        CancellationToken cancellationToken)
    {
        // 1. Check business rules
        var existingUser = await repository.GetByEmailAsync(request.Email, cancellationToken);
        if (existingUser is not null)
            return Result<AuthResponseDto>.Failure(Error.Conflict("Email already registered"));

        // 2. Create entity (domain logic)
        var user = User.Create(request.FirstName, request.LastName, request.Email);

        // 3. Persist
        await repository.AddAsync(user, cancellationToken);
        await repository.SaveChangesAsync(cancellationToken);

        // 4. Publish domain events (after SaveChanges)
        foreach (var domainEvent in user.DomainEvents)
            await _eventPublisher.PublishAsync(domainEvent, cancellationToken);
        user.ClearDomainEvents();

        // 5. Return result
        return Result<AuthResponseDto>.Success(mapper.Map<AuthResponseDto>(user));
    }
}
```

## Validator (FluentValidation)

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

        RuleFor(x => x.FirstName)
            .NotEmpty()
            .MaximumLength(100);
    }
}
```

## Kurallar

1. **Her Command/Query bir Handler'a sahip olmali**
2. **Her Command bir Validator'a sahip olmali** (Query icin opsiyonel)
3. **Handler sadece orchestrate eder** - business logic entity'de
4. **Result pattern kullan** - exception yerine
5. **Domain events SaveChanges'den sonra publish edilir**
6. **CancellationToken her zaman kabul edilmeli ve gecilmeli**

## Controller'da Kullanim

```csharp
[HttpPost("register")]
public async Task<IActionResult> Register(
    [FromBody] RegisterCommand command,
    CancellationToken cancellationToken)
{
    var result = await _mediator.Send(command, cancellationToken);

    return result.Match(
        onSuccess: value => CreatedAtAction(nameof(GetUser), new { id = value.UserId }, value),
        onFailure: error => error.Type switch
        {
            ErrorType.Conflict => Conflict(error),
            ErrorType.Validation => BadRequest(error),
            _ => StatusCode(500, error)
        }
    );
}
```
