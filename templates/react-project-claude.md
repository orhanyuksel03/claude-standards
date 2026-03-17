# {PROJECT_NAME} - Claude Code Session Instructions

> Yeni React/Next.js projesi icin CLAUDE.md template'i.
> Placeholder'lari projeye gore degistirin.

---

## Proje Bilgileri

```text
Project: {PROJECT_NAME}
Type: {PROJECT_TYPE} (SPA / Next.js / Admin Panel)
Stack: React {REACT_VERSION} + {STATE_MGMT} + {STYLING}
Port: {PORT}
API Backend: {BACKEND_URL}
```

## Session Baslangici

```text
✅ {PROJECT_NAME} hazir (Stack: React + TypeScript, Mimari: Component-based, Sayfalar: {PAGE_COUNT})
```

## Proje Yapisi

```text
{PROJECT_NAME}/
├── src/
│   ├── components/
│   │   ├── common/          → Reusable UI (Button, Input, Modal)
│   │   ├── layout/          → Header, Footer, Sidebar
│   │   └── {feature}/       → Feature-specific components
│   ├── pages/               → Page components
│   ├── hooks/               → Custom hooks
│   ├── services/            → API service layer
│   ├── store/               → State management
│   ├── utils/               → Helper functions
│   ├── types/               → TypeScript types
│   └── styles/              → Global styles, themes
├── public/
├── package.json
└── tsconfig.json
```

## Sayfalar ve Ozellikler

- {PAGE_1}: {DESCRIPTION}
- {PAGE_2}: {DESCRIPTION}
- {PAGE_3}: {DESCRIPTION}

## API Entegrasyonu

Backend: `{BACKEND_URL}`

```text
{SERVICE_NAME}Service → /api/v1/{resource}
```

## Common Commands

```bash
# Development server
npm run dev

# Build
npm run build

# Test
npm test

# Lint
npm run lint
```

---

**Last Updated:** {DATE}
