# Documentation Standards

## Is Bittiginde Guncellenmesi Gerekenler

### 1. CHANGELOG.md

Keep a Changelog + Semantic Versioning formatini kullan.

- Kategori basliklari: Ingilizce (Added, Changed, Removed, Fixed)
- Icerik: Turkce veya Ingilizce (projeye gore)
- [Unreleased] bolumu devam eden isler icin kullanilir

```markdown
## [1.2.0] - 2026-02-13

### Added
- User authentication system eklendi
- New endpoint: POST /api/auth/login

### Fixed
- Memory leak duzeltildi (user session cleanup)
```

### 2. Test Senaryosu (Yeni feature icin)

- Manuel test checklist hazirla
- Happy path + edge cases + error cases
- Frontend: UI testi, responsive testi
- Backend: API testi, authentication testi, validation testi

### 3. API Dokumantasyonu (Backend icin)

`docs/API-ENDPOINTS.md` veya Swagger/OpenAPI dokumantasyonunu guncelle:

- Endpoint path + HTTP method
- Request/Response body ornekleri
- Authentication gereksinimleri
- Error responses

### 4. Component Dokumantasyonu (Frontend icin)

- Component'in ne yaptigini acikla
- Props/parameters listesi
- Usage ornekleri

### 5. Architecture Docs (Major degisikliklerde)

`docs/ARCHITECTURE.md`: Mimari degisiklik varsa guncelle

---

## Session Bitis Kontrol Listesi

Is bittikten sonra once kullaniciya sor:

```text
✅ Gelistirme tamamlandi!

Test ettiniz mi? Dokumantasyon guncellemelerini yapayim mi?

Guncellenecekler:
- CHANGELOG.md (Semantic versioning entry)
- Test Senaryosu (Manual test checklist)
- API/Component Dokumantasyonu (Yeni ekleme varsa)
- Architecture Docs (Major degisiklik varsa)
```

Kullanici "Evet" derse guncelle, "Hayir" derse sadece kodu teslim et.

---

## Backend API Test Template

```markdown
### [Feature Name] Test Senaryosu

#### Setup
- [ ] Database/Storage hazir
- [ ] Test user'lari var
- [ ] Development server calisiyor

#### Test Cases

##### 1. Happy Path
- [ ] Request: [HTTP method + endpoint]
- [ ] Expected: 200/201 OK

##### 2. Validation Errors
- [ ] Invalid input gonder → 400 Bad Request

##### 3. Authentication
- [ ] Token olmadan istek → 401 Unauthorized

##### 4. Authorization
- [ ] Yanlis role ile istek → 403 Forbidden

##### 5. Edge Cases
- [ ] Duplicate kayit olusturmaya calis
- [ ] Olmayan kayda erismek
- [ ] Cok uzun degerler gonder
```

## Frontend UI Test Template

```markdown
### [Feature Name] Test Senaryosu

#### Test Cases

##### 1. Component Render
- [ ] Component dogru render oluyor
- [ ] Tum prop'lar dogru calisiyor

##### 2. User Interaction
- [ ] Button click calisiyor
- [ ] Form submit calisiyor
- [ ] Validation calisiyor

##### 3. Responsive Design
- [ ] Mobile view (< 768px)
- [ ] Tablet view (768px - 1024px)
- [ ] Desktop view (> 1024px)

##### 4. Error Handling
- [ ] API error handling
- [ ] Loading states
```
