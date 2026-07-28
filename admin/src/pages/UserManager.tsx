import React from 'react';
import { Box, Typography, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper, Chip } from '@mui/material';

export const UserManager: React.FC = () => {
  const users = [
    { name: 'Alex Morgan', email: 'alex.morgan@newsx.ai', role: 'Super Admin', streak: '14 Days', read: 142 },
    { name: 'Sarah Jenkins', email: 'sarah@newsx.ai', role: 'Editor', streak: '9 Days', read: 84 },
    { name: 'David Kim', email: 'david@newsx.ai', role: 'Moderator', streak: '21 Days', read: 210 },
  ];

  return (
    <Box sx={{ p: 4 }}>
      <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff', mb: 4 }}>User & Role Management</Typography>
      <TableContainer component={Paper} sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell sx={{ color: '#94A3B8' }}>User</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Email</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Role</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Reading Streak</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {users.map((u) => (
              <TableRow key={u.email}>
                <TableCell sx={{ color: '#fff', fontWeight: 'bold' }}>{u.name}</TableCell>
                <TableCell sx={{ color: '#94A3B8' }}>{u.email}</TableCell>
                <TableCell><Chip label={u.role} size="small" color="primary" /></TableCell>
                <TableCell sx={{ color: '#F59E0B', fontWeight: 'bold' }}>🔥 {u.streak}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};
