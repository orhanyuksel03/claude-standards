# React Testing Standards

## Teknoloji Stack

- **Test Runner:** Jest / Vitest
- **Component Testing:** React Testing Library
- **E2E:** Playwright / Cypress (opsiyonel)

## Test Naming

Pattern: `should [expected behavior] when [scenario]`

```tsx
describe('UserProfile', () => {
  it('should render user name when data is loaded', () => { ... });
  it('should show loading spinner when data is fetching', () => { ... });
  it('should display error message when API call fails', () => { ... });
  it('should call onUpdate when edit button is clicked', () => { ... });
});
```

## Component Testing

```tsx
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserProfile } from './UserProfile';

describe('UserProfile', () => {
  it('should render user name when data is loaded', async () => {
    // Arrange
    render(<UserProfile userId="123" />);

    // Act & Assert
    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });
  });

  it('should call onUpdate when edit button is clicked', async () => {
    // Arrange
    const mockOnUpdate = jest.fn();
    render(<UserProfile userId="123" isEditable onUpdate={mockOnUpdate} />);

    // Act
    await userEvent.click(screen.getByRole('button', { name: /edit/i }));

    // Assert
    expect(mockOnUpdate).toHaveBeenCalledTimes(1);
  });

  it('should show loading spinner when data is fetching', () => {
    render(<UserProfile userId="123" />);
    expect(screen.getByRole('progressbar')).toBeInTheDocument();
  });
});
```

## Hook Testing

```tsx
import { renderHook, waitFor } from '@testing-library/react';
import { useAuth } from './useAuth';

describe('useAuth', () => {
  it('should return authenticated user after login', async () => {
    const { result } = renderHook(() => useAuth(), { wrapper: AuthProvider });

    await act(async () => {
      await result.current.login({ email: 'test@test.com', password: 'pass' });
    });

    expect(result.current.isAuthenticated).toBe(true);
    expect(result.current.user).toBeDefined();
  });
});
```

## Test Yapisi

```text
tests/ veya __tests__/
├── components/
│   ├── UserProfile.test.tsx
│   └── LoginForm.test.tsx
├── hooks/
│   └── useAuth.test.tsx
├── services/
│   └── userService.test.ts
└── utils/
    └── formatDate.test.ts
```

## Kurallar

1. **User-centric testing** - Implementation detail degil, kullanici davranisi test et
2. **screen.getByRole** tercih et (accessibility-friendly)
3. **userEvent** kullan (fireEvent yerine - daha gercekci)
4. **Mock API calls** (MSW veya jest.mock ile)
5. **Snapshot testing** dikkatli kullan (cok kirilgan olabilir)
