# {SERVICE_DISPLAY_NAME} - Claude Code Session Instructions

> Yeni .NET mikroservis icin CLAUDE.md template'i.
> Placeholder'lari projeye gore degistirin.

---

## Servis Bilgileri

```text
Service: {SERVICE_NAME}
Type: {MODULE_TYPE} (Core/Optional)
Database: {DB_NAME}
Port: {PORT}
Dependencies: {DEPENDENCIES}
Depended By: {DEPENDED_BY}
```

## Session Baslangici

```text
✅ {SERVICE_DISPLAY_NAME} Context Loaded

📍 Service: {SERVICE_NAME} ({MODULE_TYPE})
🗄️ Database: {DB_NAME}
🔐 Primary: {PRIMARY_RESPONSIBILITY}
🔗 Dependencies: {DEPENDENCIES}

✅ Context loaded:
   - Main project standards
   - Service-specific rules
   - Architecture documentation

🎯 Ready for:
   - Feature implementation
   - Bug fixes
   - Unit/Integration test writing
   - API endpoint development
```

## Proje Yapisi

```text
{SERVICE_NAME}/
├── {SERVICE_NAME}.API/
├── {SERVICE_NAME}.Application/
├── {SERVICE_NAME}.Domain/
├── {SERVICE_NAME}.Infrastructure/
├── {SERVICE_NAME}.UnitTests/
├── {SERVICE_NAME}.IntegrationTests/
├── .claude/
│   └── memory/MEMORY.md
├── CLAUDE.md (bu dosya)
├── CHANGELOG.md
└── {SERVICE_NAME}.sln
```

## Sorumluluklar

### ✅ Bu Servisin Sorumlulugu

- {RESPONSIBILITY_1}
- {RESPONSIBILITY_2}
- {RESPONSIBILITY_3}

### ❌ Bu Servisin Sorumlulugu DEGIL

- Cross-service degisiklikler → Root directory'ye gec
- Infrastructure updates → Root directory'ye gec
- Docker Compose degisiklikleri → Root directory'ye gec

## API Endpoints

```text
{HTTP_METHOD} /api/v1/{RESOURCE}          → {DESCRIPTION}
{HTTP_METHOD} /api/v1/{RESOURCE}/{id}     → {DESCRIPTION}
```

## Database Tables

- {TABLE_1}
- {TABLE_2}
- {TABLE_3}

## Common Commands

```bash
# Run tests
dotnet test

# Create migration
dotnet ef migrations add MigrationName \
    -p {SERVICE_NAME}.Infrastructure \
    -s {SERVICE_NAME}.API

# Update database
dotnet ef database update \
    -p {SERVICE_NAME}.Infrastructure \
    -s {SERVICE_NAME}.API

# Run API
cd {SERVICE_NAME}.API
dotnet run
```

## Cross-Service Impact

### KRITIK (Alert ver)

- API contract degisiklikleri
- Domain event payload degisiklikleri
- Authentication/authorization degisiklikleri

### LOKAL (Sadece servis icinde)

- Private methods
- Internal DTOs
- Query optimizasyonlari
- Cache ayarlari

---

**Last Updated:** {DATE}
**Module Type:** {MODULE_TYPE}
