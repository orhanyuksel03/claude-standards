# .NET Testing Standards

## Teknoloji Stack

- **Framework:** xUnit
- **Mocking:** Moq
- **Assertions:** FluentAssertions
- **Integration:** Testcontainers + WebApplicationFactory
- **Coverage Hedefi:** %80

## Test Method Naming

Pattern: `MethodName_Scenario_ExpectedBehavior`

```csharp
[Fact]
public async Task Handle_ValidCommand_ShouldCreateUser()

[Fact]
public async Task Handle_DuplicateEmail_ShouldReturnConflictError()

[Fact]
public async Task GetByIdAsync_ExistingUser_ShouldReturnUser()

[Fact]
public async Task GetByIdAsync_NonExistingUser_ShouldReturnNull()
```

## AAA Pattern (Arrange-Act-Assert)

```csharp
[Fact]
public async Task Handle_ValidCommand_ShouldCreateUser()
{
    // Arrange
    var command = new RegisterCommand
    {
        FirstName = "John",
        LastName = "Doe",
        Email = "john@example.com",
        Password = "SecureP@ss123"
    };
    _mockRepository
        .Setup(x => x.GetByEmailAsync(command.Email, default))
        .ReturnsAsync((User?)null);

    // Act
    var result = await _handler.Handle(command, CancellationToken.None);

    // Assert
    result.IsSuccess.Should().BeTrue();
    result.Value.Should().NotBeNull();
    _mockRepository.Verify(
        x => x.AddAsync(It.IsAny<User>(), It.IsAny<CancellationToken>()),
        Times.Once);
}
```

## Unit Test Kurallari

1. **Her Command/Query Handler icin unit test yazilmali**
2. **Tum dependency'ler mock'lanmali**
3. **Happy path + error cases test edilmeli**
4. **FluentAssertions kullan** (`Should()`, `Be()`, `BeTrue()`)

### Unit Test Structure

```text
{ServiceName}.UnitTests/
├── Features/
│   ├── Auth/
│   │   ├── Commands/
│   │   │   ├── RegisterCommandHandlerTests.cs
│   │   │   └── LoginCommandHandlerTests.cs
│   │   └── Queries/
│   │       └── GetUserByIdQueryHandlerTests.cs
│   └── Users/
│       └── ...
└── Domain/
    └── Entities/
        └── UserTests.cs
```

## Integration Test Kurallari

1. **Her API endpoint icin integration test yazilmali**
2. **Testcontainers ile gercek database kullan**
3. **WebApplicationFactory kullan**

```csharp
[Fact]
public async Task Register_ValidRequest_Returns201Created()
{
    // Arrange
    var request = new
    {
        firstName = "John",
        lastName = "Doe",
        email = "john@test.com",
        password = "SecureP@ss123"
    };

    // Act
    var response = await _client.PostAsJsonAsync("/api/v1/auth/register", request);

    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Created);
}
```

### Integration Test Structure

```text
{ServiceName}.IntegrationTests/
├── Controllers/
│   ├── AuthControllerTests.cs
│   └── UsersControllerTests.cs
├── Fixtures/
│   ├── CustomWebApplicationFactory.cs
│   └── DatabaseFixture.cs
└── appsettings.Testing.json
```

## Common Commands

```bash
# Run all tests
dotnet test

# Run specific test class
dotnet test --filter "FullyQualifiedName~RegisterCommandHandlerTests"

# Run with coverage
dotnet test --collect:"XPlat Code Coverage"
```
