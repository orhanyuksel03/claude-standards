# Git Workflow Standards

## Commit Message Format

Conventional Commits formati kullan:

```text
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Type Degerleri

- `feat`: Yeni ozellik
- `fix`: Bug duzeltme
- `docs`: Dokumantasyon degisikligi
- `style`: Code formatting (whitespace, semicolon vb.)
- `refactor`: Kod iyilestirme (davranis degisikligi yok)
- `perf`: Performans iyilestirmesi
- `test`: Test ekleme veya duzeltme
- `chore`: Build, dependencies, configuration degisiklikleri
- `ci`: CI/CD degisiklikleri

### Scope Ornekleri

- Backend: `auth`, `users`, `api`, `db`, `config`
- Frontend: `login`, `dashboard`, `profile`, `ui`, `hooks`

### Ornekler

```text
feat(auth): Add JWT authentication system
fix(users): Fix memory leak in user session cleanup
docs(api): Update API endpoints documentation
chore(deps): Bump react version to 18.2.0
refactor(db): Optimize query performance
test(auth): Add unit tests for login flow
```

---

## Branch Naming

- **Feature**: `feature/feature-name` veya `feat/feature-name`
- **Bug fix**: `fix/bug-description` veya `bugfix/bug-description`
- **Hotfix**: `hotfix/critical-bug`
- **Release**: `release/v1.2.0`

## Merge Strategy

- Feature → `develop` branch'e merge (varsa)
- Release → `main/master` branch'e merge
- Hotfix → Hem `main` hem `develop`'a merge

## Pull Request Checklist

- [ ] Commit message'lar conventional format'ta
- [ ] Tests yazildi ve passing
- [ ] CHANGELOG.md guncellendi (major change ise)
- [ ] Dokumantasyon guncellendi (gerekirse)
- [ ] Code review yapildi
- [ ] CI/CD pipeline passing

---

## Versioning Rules (Semantic Versioning)

**MAJOR.MINOR.PATCH:**

- `PATCH` (+0.0.1) → Bug fix, minor change
- `MINOR` (+0.1.0) → New feature (backwards compatible)
- `MAJOR` (+1.0.0) → Breaking change

**Pre-release versiyonlari** (opsiyonel):

- `1.0.0-alpha.1` → Alpha (internal test)
- `1.0.0-beta.1` → Beta (public test)
- `1.0.0-rc.1` → Release Candidate
