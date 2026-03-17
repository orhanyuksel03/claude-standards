# Changelog Yazim Kurallari

## Format

**Keep a Changelog** formati + **Semantic Versioning** prensipleri kullanilir.

- **Referans**: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
- **Versioning**: [Semantic Versioning](https://semver.org/spec/v2.0.0.html)

---

## Changelog Template

```markdown
## [X.Y.Z] - YYYY-AA-GG

### Added
- Yeni ozellik aciklamasi (Turkce)

### Changed
- Degisiklik aciklamasi (Turkce)

### Removed
- Kaldirilan ozellik aciklamasi (Turkce)

### Fixed
- Duzeltilen bug aciklamasi (Turkce)
```

---

## [Unreleased] Bolumu

Devam eden isler icin kullanilir, her zaman dosyanin en ustunde bulunur.
Bos kategorileri saklamak opsiyoneldir - degisiklik yoksa kategoriyi kaldirin.

---

## Kategori Aciklamalari

### Added

Yeni ozellikler, endpoint'ler, moduller, fonksiyonlar eklendiyse.

**Ornekler:**

- Yeni CRUD modulu eklendi (Applications Management)
- Yeni endpoint eklendi: `POST /api/configurations/export`
- Bulk update ozelligi eklendi
- Yeni validation kurali eklendi (email formati kontrolu)

### Changed

Mevcut ozelliklerde degisiklik yapildiysa (davranis degisikligi, API degisikligi, refactoring, guvenlik iyilestirmeleri).

**Ornekler:**

- Database connection validation artik kaydetme sirasinda yapiliyor
- Filtreleme algoritmasi optimize edildi
- Response formati guncellendi (breaking change olabilir)
- Tenant izolasyonu guclendirildi (cross-tenant erisim engellendi)
- Password hashleme algoritmasi BCrypt'e guncellendi
- JWT token suresi 60 dakikaya indirildi

### Removed

Tamamen kaldirilan ozellikler, endpoint'ler, parametreler.

**Ornekler:**

- `DELETE /api/legacy-endpoint` endpoint kaldirildi
- `CompanyAdmin` role tamamen kaldirildi
- Eski password hashleme algoritmasi kaldirildi

### Fixed

Bug duzeltmeleri, guvenlik aciklarinin kapatilmasi.

**Ornekler:**

- Tenant izolasyonu bug'i duzeltildi (applications modulunde)
- Pagination hatasi duzeltildi (audit log filtrelemesinde)
- Null reference exception duzeltildi (config export sirasinda)
- Cross-tenant erisim acigi kapatildi
- SQL injection acigi kapatildi

---

## Yazim Kurallari

### 1. Dil

- **Kategori basliklari**: Ingilizce (Added, Changed, Removed, Fixed)
- **Icerik**: Turkce
- **Teknik terimler**: Ingilizce kalabilir (endpoint, API, token, CRUD, migration vb.)

### 2. Format

- Her degisiklik **bullet point** (tire) ile baslar
- Net ve aciklayici cumleler kullanilir
- Gerekirse alt madde eklenebilir (2 bosluk girintili)

### 3. Detay Seviyesi

- **Major feature**: Detayli aciklama + alt maddeler
- **Minor change**: Tek satir aciklama yeterli
- **Bug fix**: Hangi bug duzeltildi, nerede oldu

### 4. Versiyon Tarihi

- Format: `YYYY-AA-GG` (ISO 8601)
- Ornek: `2026-02-12`

### 5. Ornek Entry

```markdown
## [0.7.2] - 2026-02-12

### Added
- **Configuration Export Ozelligi**
  - Konfigurasyonlari JSON veya YAML formatinda disa aktarma
  - Tenant bazli veya global export destegi
  - Filtreleme secenekleri (environment, service, scope)
- Bulk update endpoint'i eklendi: `POST /api/configurations/bulk-update`

### Changed
- Database connection validation artik kaydetme sirasinda yapiliyor
- Response formati guncellendi: `data` field'i artik her zaman mevcut
- TenantAdmin kullanicilari artik sadece kendi tenant'larinin configuration'larini gorebilir

### Fixed
- Tenant izolasyonu bug'i duzeltildi (cross-tenant erisim engellendi)
- Pagination hatasi duzeltildi (sayfa numarasi yanlis hesaplaniyordu)
- SQL injection acigi kapatildi (search parametresi sanitize ediliyor)
```

---

## Semantic Versioning Kurallari

### Versiyon Numarasi: `MAJOR.MINOR.PATCH`

- **PATCH** (`0.7.1` → `0.7.2`): Bug fix, minor degisiklik, guvenlik yamasi
- **MINOR** (`0.7.0` → `0.8.0`): Yeni ozellik (backwards compatible), yeni endpoint
- **MAJOR** (`0.9.0` → `1.0.0`): Breaking change, API contract degisikligi

### PATCH Artisi

```markdown
### Fixed
- Pagination hatasi duzeltildi
- Null reference exception duzeltildi
```

### MINOR Artisi

```markdown
### Added
- Yeni Configuration Export modulu
- Yeni endpoint: POST /api/configurations/export
```

### MAJOR Artisi

```markdown
### Changed
- **BREAKING**: Response formati tamamen yenilendi
- **BREAKING**: Tum endpoint'ler artik `/api/v2/` prefix'i kullaniyor
- **BREAKING**: JWT token payload'i degisti (eski tokenlar gecersiz)
```

---

## Changelog Guncelleme Workflow'u

### Development Sirasinda

1. Yeni feature/bug fix gelistirirken **[Unreleased]** bolumune ekle
2. Dogru kategoriyi sec (Added, Fixed, Changed vb.)
3. Turkce aciklama yaz

### Release Oncesi

1. [Unreleased] bolumundeki tum degisiklikleri kontrol et
2. Semantic versioning kurallarina gore yeni versiyon numarasini belirle
3. Yeni versiyon bolumu olustur ve degisiklikleri tasi
4. Release tarihini ekle
5. [Unreleased] bolumunu temizle

### Release Sonrasi

1. Git tag olustur: `git tag vX.Y.Z`
2. GitHub release olustur (changelog'dan copy-paste)

---

## Yapilmamasi Gerekenler

```markdown
### Added
- Bug fix yapildi          ← YANLIS (Fixed kategorisinde olmali)

### Fixed
- Yeni ozellik eklendi     ← YANLIS (Added kategorisinde olmali)

### Changed
- Code cleanup             ← YANLIS (cok genel, ne degistigi belli degil)

## [0.7.2]                 ← YANLIS (tarih eksik)

### Security               ← YANLIS (kullanilmiyor, Changed veya Fixed kullan)

### Improved               ← YANLIS (standart olmayan kategori, Changed kullan)
```
