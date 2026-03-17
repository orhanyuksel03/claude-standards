# Claude Standards - Merkezi Kural ve Standart Reposu

Tum `D:\projects\` altindaki projeler icin merkezi Claude Code standartlari.

## Yapi

```text
claude-standards/
├── global/          → Tum projeler icin (git, docs, security, session)
├── dotnet/          → .NET projeleri icin (clean arch, CQRS, testing)
├── react/           → React/Next.js projeleri icin (components, state, styling)
├── microservices/   → Mikroservis projeleri icin (events, docker, API)
├── templates/       → Yeni proje CLAUDE.md template'leri
└── sync.sh          → Dagitim script'i
```

## Proje-Teknoloji Eslestirmesi

| Proje | Teknolojiler |
|-------|-------------|
| qrphoto-microservices | dotnet + microservices |
| confighub | dotnet |
| qrphoto-frontend | react |
| confighub-admin | react |

## Kullanim

### Tum Projelere Dagit

```bash
./sync.sh
```

### Pull + Dagit (Diger makinelerden)

```bash
./sync.sh pull
```

### Sync Durumunu Goster

```bash
./sync.sh status
```

## Yeni Proje Ekleme

1. `sync.sh` icindeki `PROJECT_TECHS` dizisine projeyi ekleyin
2. `./sync.sh` calistirin

## Kural Guncelleme

1. Bu repodaki ilgili dosyayi guncelleyin
2. Commit + push yapin
3. `./sync.sh` calistirin → Tum projeler guncellenir

## Yeni Servis Olusturma

`templates/` klasorundeki template'leri kullanin:

- `dotnet-service-claude.md` → .NET servis CLAUDE.md
- `react-project-claude.md` → React proje CLAUDE.md
- `clinerules-template.yaml` → Servis .clinerules

Placeholder'lari (`{SERVICE_NAME}`, `{PORT}`, `{DB_NAME}`) projenize gore degistirin.
