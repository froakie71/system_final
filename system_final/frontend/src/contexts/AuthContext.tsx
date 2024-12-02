'use client';

import { createContext, useState, useEffect, ReactNode } from 'react';
import axios from '@/lib/axios';
import { useRouter } from 'next/navigation';
import { setCookie, deleteCookie } from 'cookies-next';

export interface AuthContextType {
  user: any;
  loading: boolean;
  login: (credentials: { email: string; password: string }) => Promise<void>;
  logout: () => Promise<void>;
}

export const AuthContext = createContext({} as AuthContextType);

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  const checkAuth = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setLoading(false);
        return;
      }

      setCookie('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      
      const response = await axios.get('http://localhost:8000/api/frontend/user');
      if (response.data) {
        setUser(response.data);
      }
    } catch (error) {
      console.error('Auth check failed:', error);
      localStorage.removeItem('token');
      deleteCookie('token');
      delete axios.defaults.headers.common['Authorization'];
      setUser(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    checkAuth();
  }, []);

  const login = async (credentials: { email: string; password: string }) => {
    try {
      const response = await axios.post('http://localhost:8000/api/frontend/login', credentials);
      const { token, user } = response.data;
      
      localStorage.setItem('token', token);
      setCookie('token', token);
      axios.defaults.headers.common['Authorization'] = `Bearer ${token}`;
      
      setUser(user);
      router.replace('/dashboard');
    } catch (error) {
      console.error('Login failed:', error);
      throw error;
    }
  };

  const logout = async () => {
    try {
      await axios.post('http://localhost:8000/api/frontend/logout');
    } catch (error) {
      console.error('Logout error:', error);
    } finally {
      localStorage.removeItem('token');
      deleteCookie('token');
      delete axios.defaults.headers.common['Authorization'];
      setUser(null);
      router.replace('/auth/login');
    }
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
} 