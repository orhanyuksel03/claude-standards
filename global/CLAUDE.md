# Global Standards - Tum Projeler Icin Gecerli Kurallar

> Bu dosya tum projelerde gecerli olan genel kurallari icerir.
> Teknoloji-ozel kurallar icin ilgili klasore bakin (dotnet/, react/, microservices/).

---

## Session Baslangic Protokolu

Her session acildiginda otomatik olarak:

### 1. Proje Kesfi (Project Discovery)

#### Stack Detection

Asagidaki dosyalari kontrol ederek stack'i tespit et:

- `package.json` → Node.js/React/Vue/Angular/Next.js
- `*.csproj` / `*.sln` → .NET/C#
- `requirements.txt` / `pyproject.toml` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust

#### Architecture Detection

Klasor yapisindan mimariyi cikar:

- `src/Domain/`, `src/Application/`, `src/Infrastructure/` → Clean Architecture
- `src/components/`, `src/pages/`, `src/hooks/` → React/Vue frontend
- `app/`, `models/`, `controllers/` → MVC pattern

#### Documentation Discovery

Su konumlarda dokumantasyon ara (varsa otomatik oku):

1. `docs/Egitim_Dokumani/INDEX.md`
2. `docs/ARCHITECTURE.md`
3. `docs/API-ENDPOINTS.md`
4. Root `README.md` (sadece overview icin)

#### Module/Entity Detection

- Backend: `src/Domain/Entities/` veya `models/` klasorunu tara
- Frontend: `src/features/`, `src/modules/`, `src/pages/` klasorlerini tara
- API: Controller'lari veya route dosyalarini tara

### 2. Versiyon ve Durum Tespiti

- `CHANGELOG.md` dosyasindan mevcut versiyonu ogren
- `package.json` / `*.csproj` icindeki version field'ini kontrol et
- Git branch'ini kontrol et

### 3. Kullaniciya Minimal Mesaj

```text
✅ [Proje Adi] hazir (Stack: [detected], Mimari: [detected], Moduller: [count])
```

### 4. Talimat Bekle

Kullanicinin ilk talimatini bekle. Istenmedikce ekstra aciklama yapma.

---

## Development Workflow

### Yeni Feature Eklerken

1. Feature branch olustur: `feature/feature-name`
2. Mimari kurallarina uy (layer/module sirasina gore)
3. Testleri yaz
4. Local'de calistir ve dogrula
5. Is bittiginde Session Bitis Kontrol Listesi'ni uygula

### Bug Fix Workflow

1. Bug'in hangi layer/module/component'te oldugunu belirle
2. Root cause'u bul ve fix uygula
3. Regression test yap
4. CHANGELOG.md'ye `fix:` formatiyla ekle

### Refactoring

1. Mevcut testleri koru (varsa)
2. Mimari prensiplere uy (Clean Architecture, SOLID, DRY)
3. Dependency injection/inversion kullan (backend icin)

---

## Detayli kurallar icin `rules/` klasorune bakin:

- `rules/session-protocol.md` - Session protokolu detaylari
- `rules/git-workflow.md` - Git ve commit kurallari
- `rules/changelog.md` - Changelog yazim kurallari (Keep a Changelog + SemVer)
- `rules/documentation.md` - Dokumantasyon gereksinimleri
- `rules/security-generic.md` - Genel guvenlik kurallari
