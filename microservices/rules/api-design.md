# API Design & Cross-Service Impact Standards

## API Versioning

- URL-based versioning: `/api/v1/`, `/api/v2/`
- Breaking change = yeni versiyon
- Eski versiyon deprecated ama bir sure desteklenir

## Cross-Service Impact Detection

Her degisiklikte su kontrolleri yap:

### KRITIK (Tum servisleri etkiler - Alert ver)

- JWT token yapisi (claims, expiry, algorithm)
- User entity public field'lari
- API contract degisiklikleri (endpoint path, request/response)
- Domain event payload degisiklikleri
- Authentication flow degisiklikleri
- Password policy degisiklikleri

### LOKAL (Sadece servis memory guncelle)

- Private methods
- Internal DTOs
- Database query optimizasyonlari
- Cache TTL degerleri
- Logging iyilestirmeleri
- Bug fix'ler (contract degistirmeyen)

### Alert Template

```text
⚠️ CROSS-SERVICE IMPACT DETECTED!

Bu degisiklik etkiler: [servis listesi]

Oneri:
1. Servis memory'sini guncelle
2. Ana proje memory'sini guncelle
3. Breaking change'leri dokumante et
4. Gerekirse API versioning uygula
```

## API Contract Kurallari

### Request/Response Format

```json
{
  "isSuccess": true,
  "data": { ... },
  "error": null
}

{
  "isSuccess": false,
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Email is required",
    "details": [...]
  }
}
```

### HTTP Status Codes

- `200` OK - Basarili GET/PUT
- `201` Created - Basarili POST
- `204` No Content - Basarili DELETE
- `400` Bad Request - Validation error
- `401` Unauthorized - Auth gerekli
- `403` Forbidden - Yetki yetersiz
- `404` Not Found - Kayit bulunamadi
- `409` Conflict - Duplicate kayit
- `500` Internal Server Error

### Endpoint Naming

```text
GET    /api/v1/{resource}          → List
GET    /api/v1/{resource}/{id}     → Get by ID
POST   /api/v1/{resource}          → Create
PUT    /api/v1/{resource}/{id}     → Update
DELETE /api/v1/{resource}/{id}     → Delete
```

## Kurallar

1. **Backward compatible degisiklikler** tercih et
2. **Breaking change** yapacaksan yeni API versiyon olustur
3. **Cross-service impact** kontrolunu her zaman yap
4. **Shared contracts** bir yerde dokumante et
5. **Swagger/OpenAPI** her endpoint icin guncelle
