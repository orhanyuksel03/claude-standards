# State Management Standards

## State Tipleri

### Local State (useState)

Component'e ozel, basit state icin:

```tsx
const [isOpen, setIsOpen] = useState(false);
const [searchTerm, setSearchTerm] = useState('');
```

### Shared State (Context / Zustand)

Birden fazla component arasinda paylasilan state icin:

```tsx
// Context ornegi
const AuthContext = createContext<AuthContextType | null>(null);

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<User | null>(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);

  const login = async (credentials: LoginCredentials) => { ... };
  const logout = async () => { ... };

  return (
    <AuthContext.Provider value={{ user, isAuthenticated, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
}
```

### Server State (React Query / SWR)

API'den gelen veriler icin:

```tsx
function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => UserService.getAll(),
    staleTime: 5 * 60 * 1000, // 5 minutes
  });
}
```

## Custom Hooks

Logic'i component'ten ayirmak icin custom hook kullan:

```tsx
// ✅ Good: Logic hook'ta
function useUserProfile(userId: string) {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const loadUser = async () => {
      try {
        setIsLoading(true);
        const data = await UserService.getById(userId);
        setUser(data);
      } catch (err) {
        setError('Failed to load user');
      } finally {
        setIsLoading(false);
      }
    };
    loadUser();
  }, [userId]);

  return { user, isLoading, error };
}

// Component'te kullanim
function UserProfile({ userId }: { userId: string }) {
  const { user, isLoading, error } = useUserProfile(userId);
  // render logic only
}
```

## Kurallar

1. **State'i mumkun oldugunca lokal tut** (lift up only when necessary)
2. **Derived state icin useMemo kullan** (gereksiz state olusturma)
3. **Side effects icin useEffect kullan** (ve cleanup yap)
4. **Context'i kucuk tut** (buyuk context yerine birden fazla kucuk context)
5. **Server state icin React Query/SWR kullan** (manuel fetch + state yerine)
