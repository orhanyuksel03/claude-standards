# Session Protocol Details

## Otomatik Proje Kesfi Detaylari

### Stack Detection Dosyalari

| Dosya | Teknoloji |
|-------|-----------|
| `package.json` | Node.js / React / Vue / Angular / Next.js |
| `*.csproj` / `*.sln` | .NET / C# |
| `requirements.txt` / `pyproject.toml` | Python |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pom.xml` / `build.gradle` | Java |
| `Gemfile` | Ruby |
| `composer.json` | PHP |

### Architecture Detection Patterns

| Klasor Yapisi | Mimari |
|---------------|--------|
| `src/Domain/`, `src/Application/`, `src/Infrastructure/` | Clean Architecture |
| `src/components/`, `src/pages/`, `src/hooks/` | React/Vue Frontend |
| `app/`, `models/`, `controllers/` | MVC Pattern |
| `cmd/`, `internal/`, `pkg/` | Go Standard Layout |
| `layers/`, `modules/` | Modular Architecture |

### Documentation Discovery Priority

1. `docs/Egitim_Dokumani/INDEX.md` (Egitim/Onboarding)
2. `docs/ARCHITECTURE.md` (Mimari)
3. `docs/API-ENDPOINTS.md` (API)
4. Root `README.md` (sadece overview)

### Versiyon Tespiti

1. `CHANGELOG.md` → En son versiyon
2. `package.json` → `version` field
3. `*.csproj` → `<Version>` element
4. Git tag → `git describe --tags`

### Cikti Formati

```text
✅ [Proje Adi] hazir (Stack: [detected], Mimari: [detected], Moduller: [count])
```

Ornekler:

```text
✅ ConfigHub hazir (Stack: .NET 8.0 + PostgreSQL, Mimari: Clean Architecture, Moduller: 6)
✅ QRPhoto Frontend hazir (Stack: React 18 + TypeScript, Mimari: Component-based, Sayfalar: 12)
```
