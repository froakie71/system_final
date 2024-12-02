import axios from '@/lib/axios';

export const login = async (email: string, password: string) => {
  const response = await axios.post('/api/frontend/login', { email, password });
  if (response.data.token) {
    localStorage.setItem('token', response.data.token);
  }
  return response.data;
};

export const register = async (
  name: string,
  email: string,
  password: string,
  password_confirmation: string
) => {
  const response = await axios.post('/api/frontend/register', {
    name,
    email,
    password,
    password_confirmation,
  });
  return response.data;
};

export const logout = async () => {
  await axios.post('/api/frontend/logout');
  localStorage.removeItem('token');
};

export const getUser = async () => {
  const response = await axios.get('/api/frontend/user');
  return response.data;
};
