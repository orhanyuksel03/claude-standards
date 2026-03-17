# React/Next.js Standards - Tum Frontend Projeleri Icin

> React ve Next.js projelerinde uygulanacak standartlar.
> Detayli kurallar `rules/` klasorunde bulunur.

---

## Teknoloji Stack

- **React 18+** / Next.js
- **TypeScript** (tercih edilen)
- **CSS Modules / Tailwind CSS** (projeye gore)
- **Zustand / React Context** (state management)
- **Axios / Fetch** (API calls)
- **React Hook Form + Zod** (form validation)
- **Jest + React Testing Library** (testing)

## Proje Yapisi

```text
project-root/
├── src/
│   ├── components/      → Reusable UI components
│   │   ├── common/      → Button, Input, Modal, etc.
│   │   └── layout/      → Header, Footer, Sidebar
│   ├── pages/           → Page components (Next.js: app/ or pages/)
│   ├── hooks/           → Custom hooks
│   ├── services/        → API service layer
│   ├── store/           → State management
│   ├── utils/           → Helper functions
│   ├── types/           → TypeScript types/interfaces
│   └── styles/          → Global styles, themes
├── public/              → Static assets
├── tests/               → Test files
├── package.json
└── tsconfig.json
```

## Temel Kurallar Ozeti

1. **Component'ler PascalCase** ile isimlendirilir
2. **Function component** kullan (class component degil)
3. **Custom hooks** ile logic ayristirmasi yap
4. **API calls** service layer uzerinden yapilir
5. **TypeScript** ile type safety sagla
6. **Responsive design** her component icin zorunlu
7. **Accessibility** standartlarina uy (semantic HTML, ARIA)

## Detayli Kurallar

- `rules/component-standards.md` - Component yapisi ve naming
- `rules/state-management.md` - State yonetimi patterns
- `rules/styling.md` - CSS/Tailwind kurallari
- `rules/api-integration.md` - API service layer
- `rules/testing.md` - Test standartlari
