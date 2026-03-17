# API Integration Standards

## Service Layer Pattern

API call'lari dogrudan component'te yapma, service layer kullan:

```tsx
// ✅ Good: Service layer
// services/userService.ts
import { apiClient } from './apiClient';
import type { User, CreateUserRequest } from '@/types/user';

export const UserService = {
  getAll: async (): Promise<User[]> => {
    const { data } = await apiClient.get('/api/v1/users');
    return data;
  },

  getById: async (id: string): Promise<User> => {
    const { data } = await apiClient.get(`/api/v1/users/${id}`);
    return data;
  },

  create: async (request: CreateUserRequest): Promise<User> => {
    const { data } = await apiClient.post('/api/v1/users', request);
    return data;
  },

  update: async (id: string, request: Partial<User>): Promise<User> => {
    const { data } = await apiClient.put(`/api/v1/users/${id}`, request);
    return data;
  },

  delete: async (id: string): Promise<void> => {
    await apiClient.delete(`/api/v1/users/${id}`);
  },
};
```

## API Client

```tsx
// services/apiClient.ts
import axios from 'axios';

export const apiClient = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor - JWT token ekleme
apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem('accessToken');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor - Error handling
apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Token expired - try refresh
      // ...
    }
    return Promise.reject(error);
  }
);
```

## Error Handling

```tsx
// ✅ Good: Centralized error handling
function useApiCall<T>(apiCall: () => Promise<T>) {
  const [data, setData] = useState<T | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);

  const execute = async () => {
    try {
      setIsLoading(true);
      setError(null);
      const result = await apiCall();
      setData(result);
      return result;
    } catch (err) {
      const message = err instanceof Error ? err.message : 'An error occurred';
      setError(message);
      throw err;
    } finally {
      setIsLoading(false);
    }
  };

  return { data, error, isLoading, execute };
}
```

## Kurallar

1. **API URL'leri environment variable'dan oku** (`NEXT_PUBLIC_API_URL`)
2. **Service layer** kullan (component'te dogrudan fetch yapma)
3. **Interceptor'lar** ile auth token ve error handling yonet
4. **Loading state** her API call icin goster
5. **Error state** kullaniciya uygun mesajla goster
6. **Type safety** - request/response type'larini tanimla
