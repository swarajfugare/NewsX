import React, { useState } from 'react';
import { Box, Card, CardContent, Typography, TextField, Button } from '@mui/material';
import { useNavigate } from 'react-router-dom';

export const Login: React.FC = () => {
  const [email, setEmail] = useState('admin@newsx.ai');
  const [password, setPassword] = useState('admin123');
  const navigate = useNavigate();

  const handleLogin = (e: React.FormEvent) => {
    e.preventDefault();
    localStorage.setItem('newsx_admin_token', 'mock_admin_jwt_token_2026');
    navigate('/');
  };

  return (
    <Box
      sx={{
        width: '100vw',
        height: '100vh',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#0F172A',
      }}
    >
      <Card sx={{ width: 400, backgroundColor: '#1E293B', border: '1px solid #334155', p: 2 }}>
        <CardContent>
          <Box sx={{ textAlign: 'center', mb: 3 }}>
            <Typography variant="h4" sx={{ color: '#fff', fontWeight: 'bold' }}>NewsX Admin</Typography>
            <Typography variant="body2" sx={{ color: '#94A3B8' }}>Sign in to access management console</Typography>
          </Box>
          <form onSubmit={handleLogin}>
            <Box sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
              <TextField label="Email" fullWidth value={email} onChange={(e) => setEmail(e.target.value)} />
              <TextField label="Password" type="password" fullWidth value={password} onChange={(e) => setPassword(e.target.value)} />
              <Button type="submit" variant="contained" size="large" sx={{ mt: 1 }}>Sign In</Button>
            </Box>
          </form>
        </CardContent>
      </Card>
    </Box>
  );
};
