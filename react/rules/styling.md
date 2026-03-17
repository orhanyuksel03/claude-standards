# Styling Standards

## CSS Naming

- CSS class names: `kebab-case` (`user-profile`, `login-form`)
- BEM convention (opsiyonel): `block__element--modifier`

## CSS Modules (Tercih Edilen)

```tsx
import styles from './UserProfile.module.css';

function UserProfile() {
  return (
    <div className={styles.container}>
      <h2 className={styles.title}>Profile</h2>
      <p className={styles.description}>User details</p>
    </div>
  );
}
```

```css
/* UserProfile.module.css */
.container {
  padding: 1rem;
  border-radius: 8px;
}

.title {
  font-size: 1.5rem;
  font-weight: bold;
}
```

## Tailwind CSS (Projeye Gore)

```tsx
function UserProfile() {
  return (
    <div className="p-4 rounded-lg bg-white shadow-md">
      <h2 className="text-xl font-bold text-gray-900">Profile</h2>
      <p className="mt-2 text-gray-600">User details</p>
    </div>
  );
}
```

## Responsive Design

Her component responsive olmali:

```css
/* Mobile-first approach */
.container {
  padding: 0.5rem;
}

/* Tablet */
@media (min-width: 768px) {
  .container {
    padding: 1rem;
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .container {
    padding: 2rem;
  }
}
```

## Kurallar

1. **Inline style kullanma** (acil durumlar haric)
2. **Global CSS'i minimize et** (component-scoped CSS tercih et)
3. **CSS variables** kullan (tekrarlayan degerler icin)
4. **Mobile-first** yaklasim
5. **Dark mode** destegi dusun (CSS variables ile)
