# React Component Standards

## Naming Conventions

- **Components:** PascalCase (`UserProfile`, `LoginForm`, `ProductCard`)
- **Files:** PascalCase matching component name (`UserProfile.tsx`)
- **Hooks:** camelCase with `use` prefix (`useAuth`, `useUserData`)
- **Utils/Helpers:** camelCase (`formatDate`, `calculateTotal`)
- **Constants:** UPPER_SNAKE_CASE (`API_URL`, `MAX_FILE_SIZE`)
- **CSS classes:** kebab-case (`user-profile`, `login-form`)
- **Event handlers:** `handle` prefix (`handleClick`, `handleSubmit`)
- **Boolean props:** `is`/`has`/`should` prefix (`isLoading`, `hasError`)

## Component Structure

```tsx
// ✅ Good: Function component with clear structure
import { useState, useEffect } from 'react';

import { UserService } from '@/services/userService';
import { Button } from '@/components/common/Button';

import type { User } from '@/types/user';

import styles from './UserProfile.module.css';

interface UserProfileProps {
  userId: string;
  isEditable?: boolean;
  onUpdate?: (user: User) => void;
}

export function UserProfile({ userId, isEditable = false, onUpdate }: UserProfileProps) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    loadUser();
  }, [userId]);

  const loadUser = async () => {
    setIsLoading(true);
    const data = await UserService.getById(userId);
    setUser(data);
    setIsLoading(false);
  };

  if (isLoading) return <LoadingSpinner />;
  if (!user) return <NotFound />;

  return (
    <div className={styles.container}>
      <h2>{user.name}</h2>
      {isEditable && <Button onClick={() => onUpdate?.(user)}>Edit</Button>}
    </div>
  );
}
```

## Component Kurallari

1. **Function component** kullan (class component degil)
2. **Named export** kullan (default export degil - Next.js pages haric)
3. **Props interface** tanimla (inline type yerine)
4. **Destructure props** function parametresinde
5. **Optional props** icin default deger ver
6. **Bir dosya = bir component** (kucuk helper component'ler haric)

## Import Sirasi

1. React / framework imports
2. Third-party library imports
3. Internal component imports
4. Service / utility imports
5. Type imports
6. Style imports

## Component Tipleri

### Page Components

```text
pages/
├── LoginPage.tsx         → Tam sayfa, routing ile eslesir
├── DashboardPage.tsx
└── UserProfilePage.tsx
```

### Feature Components

```text
components/
├── auth/
│   ├── LoginForm.tsx     → Feature-specific
│   └── RegisterForm.tsx
└── users/
    ├── UserList.tsx
    └── UserCard.tsx
```

### Common/Shared Components

```text
components/common/
├── Button.tsx
├── Input.tsx
├── Modal.tsx
├── Table.tsx
└── LoadingSpinner.tsx
```
