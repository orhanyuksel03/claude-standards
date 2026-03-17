# Entity Framework Core Standards

## Genel Kurallar

- **Yaklasim:** Code-First
- **Provider:** Npgsql (PostgreSQL)
- **Database per Service** (mikroservislerde)

## Migration Kurallari

### Migration Adi

Aciklayici olmali: `Add{Feature}`, `Update{Entity}`, `Remove{Column}`

### Migration Komutlari

```bash
# Migration olustur
dotnet ef migrations add MigrationName \
    -p {ServiceName}.Infrastructure \
    -s {ServiceName}.API

# Database guncelle
dotnet ef database update \
    -p {ServiceName}.Infrastructure \
    -s {ServiceName}.API

# Migration geri al
dotnet ef database update PreviousMigrationName \
    -p {ServiceName}.Infrastructure \
    -s {ServiceName}.API
```

### Migration Best Practices

- Migration oncesi database backup al (production)
- Seed data sadece development icin
- Rollback stratejisi hazirla
- Her servis kendi migration'larini yonetir

## DbContext

```csharp
public class AppDbContext : DbContext
{
    public DbSet<User> Users => Set<User>();
    public DbSet<Role> Roles => Set<Role>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);
    }
}
```

## Entity Configuration

```csharp
public class UserConfiguration : IEntityTypeConfiguration<User>
{
    public void Configure(EntityTypeBuilder<User> builder)
    {
        builder.HasKey(u => u.Id);

        builder.Property(u => u.Email)
            .IsRequired()
            .HasMaxLength(255);

        builder.HasIndex(u => u.Email)
            .IsUnique();

        builder.HasMany(u => u.Roles)
            .WithMany(r => r.Users)
            .UsingEntity<UserRole>();
    }
}
```

## Query Best Practices

```csharp
// ✅ Good: Select only needed columns
var userDto = await _context.Users
    .Where(u => u.Id == userId)
    .Select(u => new UserDto(u.Id, u.FirstName, u.Email))
    .FirstOrDefaultAsync(cancellationToken);

// ✅ Good: Use AsNoTracking for read-only queries
var users = await _context.Users
    .AsNoTracking()
    .Where(u => u.Status == UserStatus.Active)
    .ToListAsync(cancellationToken);

// ❌ Bad: Loading entire entity when only need DTO
var user = await _context.Users.FindAsync(userId);
return new UserDto(user.Id, user.FirstName, user.Email);
```

## Database Naming

- **Database:** `{service}_db` (auth_db, event_db)
- **Tables:** PascalCase (Users, Events, Roles)
- **Columns:** PascalCase (FirstName, CreatedAt)
- **Indexes:** Gerekli kolonlara index ekle (Email, UserId)

## Connection Strings

```csharp
// Container → Container
"Host=postgres;Port=5432;Database=auth_db;Username=postgres;Password=postgres123;"

// Host → Container (development)
"Host=localhost;Port=5432;Database=auth_db;Username=postgres;Password=postgres123;"
```

Connection string'ler environment variable veya appsettings'den okunmali, asla hard-code yapilmamali.
