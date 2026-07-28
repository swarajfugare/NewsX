import React from 'react';
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';
import { ThemeProvider, Box, CssBaseline } from '@mui/material';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { darkTheme } from './theme/theme';
import { Sidebar } from './components/Sidebar';
import { Header } from './components/Header';
import { Dashboard } from './pages/Dashboard';
import { NewsManager } from './pages/NewsManager';
import { CategoryManager } from './pages/CategoryManager';
import { RssManager } from './pages/RssManager';
import { AiManager } from './pages/AiManager';
import { UserManager } from './pages/UserManager';
import { NotificationManager } from './pages/NotificationManager';
import { Login } from './pages/Login';

const queryClient = new QueryClient();

const ProtectedLayout: React.FC = () => {
  const token = localStorage.getItem('newsx_admin_token');
  if (!token) return <Navigate to="/login" replace />;

  return (
    <Box sx={{ display: 'flex', minHeight: '100vh', backgroundColor: '#0F172A' }}>
      <Sidebar />
      <Box sx={{ flexGrow: 1, display: 'flex', flexDirection: 'column' }}>
        <Header />
        <Box sx={{ flexGrow: 1, backgroundColor: '#0F172A' }}>
          <Routes>
            <Route path="/" element={<Dashboard />} />
            <Route path="/news" element={<NewsManager />} />
            <Route path="/categories" element={<CategoryManager />} />
            <Route path="/rss" element={<RssManager />} />
            <Route path="/ai" element={<AiManager />} />
            <Route path="/users" element={<UserManager />} />
            <Route path="/notifications" element={<NotificationManager />} />
          </Routes>
        </Box>
      </Box>
    </Box>
  );
};

export const App: React.FC = () => {
  return (
    <QueryClientProvider client={queryClient}>
      <ThemeProvider theme={darkTheme}>
        <CssBaseline />
        <BrowserRouter>
          <Routes>
            <Route path="/login" element={<Login />} />
            <Route path="/*" element={<ProtectedLayout />} />
          </Routes>
        </BrowserRouter>
      </ThemeProvider>
    </QueryClientProvider>
  );
};
