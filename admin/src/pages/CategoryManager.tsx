import React from 'react';
import { Box, Typography, Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper, Chip } from '@mui/material';
import { Plus } from 'lucide-react';

export const CategoryManager: React.FC = () => {
  const categories = [
    { name: 'AI', slug: 'ai', icon: 'psychology_rounded', status: 'Active' },
    { name: 'Technology', slug: 'technology', icon: 'laptop_mac', status: 'Active' },
    { name: 'Business', slug: 'business', icon: 'business_center', status: 'Active' },
    { name: 'Cricket', slug: 'cricket', icon: 'sports_cricket', status: 'Active' },
    { name: 'Science', slug: 'science', icon: 'science', status: 'Active' },
  ];

  return (
    <Box sx={{ p: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff' }}>Category Management</Typography>
        <Button variant="contained" startIcon={<Plus size={18} />}>Add Category</Button>
      </Box>
      <TableContainer component={Paper} sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell sx={{ color: '#94A3B8' }}>Category Name</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Slug</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Icon</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Status</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {categories.map((cat) => (
              <TableRow key={cat.slug}>
                <TableCell sx={{ color: '#fff', fontWeight: 'bold' }}>{cat.name}</TableCell>
                <TableCell sx={{ color: '#94A3B8' }}>{cat.slug}</TableCell>
                <TableCell sx={{ color: '#06B6D4' }}>{cat.icon}</TableCell>
                <TableCell><Chip label={cat.status} size="small" color="success" /></TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};
