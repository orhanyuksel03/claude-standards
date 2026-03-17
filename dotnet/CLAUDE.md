# .NET Standards - Tum .NET Projeleri Icin

> .NET 8 / C# projelerinde uygulanacak standartlar.
> Detayli kurallar `rules/` klasorunde bulunur.

---

## Teknoloji Stack

- **.NET 8** / ASP.NET Core
- **Entity Framework Core 8** (Code-First)
- **PostgreSQL 16** (veya proje bazli DB)
- **MediatR** (CQRS pattern)
- **FluentValidation** (Input validation)
- **AutoMapper** (DTO mapping)
- **Serilog** (Structured logging)
- **xUnit + Moq + FluentAssertions** (Testing)
- **Testcontainers** (Integration tests)

## Clean Architecture (4 Katman)

```text
API Layer (Controllers, Middleware)
    ↓
Infrastructure Layer (EF Core, Redis, RabbitMQ)
    ↓
Application Layer (CQRS, MediatR, Business Logic)
    ↓
Domain Layer (Entities, Value Objects, Domain Events)
```

**Dependency yonu:** Icerideki katman disaridakini bilmez. Domain hicbir seye bagimli degildir.

## Proje Yapisi

```text
{ServiceName}/
├── {ServiceName}.API/              → Controllers, Middleware, Program.cs
├── {ServiceName}.Application/      → CQRS, Handlers, Validators, DTOs
├── {ServiceName}.Domain/           → Entities, Value Objects, Events, Enums
├── {ServiceName}.Infrastructure/   → DbContext, Repositories, External Services
├── {ServiceName}.UnitTests/        → xUnit + Moq
├── {ServiceName}.IntegrationTests/ → xUnit + Testcontainers
└── {ServiceName}.sln
```

## Temel Kurallar Ozeti

1. **Result Pattern** kullan (exception yerine business logic icin)
2. **Async/Await** everywhere + CancellationToken
3. **Records** for DTOs (immutable)
4. **FluentValidation** ile tum input dogrulama
5. **Hassas veri ASLA loglanmaz** (password, token, API key)
6. **BCrypt** ile password hashing (work factor: 12)
7. **Parametreli sorgular** (EF Core otomatik yapar)
8. **%80 test coverage** hedefi

## Detayli Kurallar

- `rules/clean-architecture.md` - Katman kurallari
- `rules/coding-standards.md` - Naming, async, DI, LINQ
- `rules/cqrs-pattern.md` - Command/Query/Handler/Validator
- `rules/security.md` - JWT, BCrypt, guvenlik
- `rules/testing.md` - Test standartlari
- `rules/ef-core.md` - EF Core ve migration kurallari
- `rules/editorconfig` - EditorConfig ayarlari
