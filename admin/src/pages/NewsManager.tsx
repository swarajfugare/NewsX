import React, { useState } from 'react';
import { Box, Typography, Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper, Chip, IconButton } from '@mui/material';
import { Plus, Edit, Trash2, Eye } from 'lucide-react';

export const NewsManager: React.FC = () => {
  const [articles] = useState([
    { id: 'news_1', title: 'OpenAI Unveils GPT-5 Engine with Multimodal Reasoning', category: 'AI', author: 'TechCrunch', status: 'Published', likes: 1420 },
    { id: 'news_2', title: 'Apple Announces M4 Ultra Mac Studio for Heavy AI Workloads', category: 'Technology', author: 'The Verge', status: 'Published', likes: 980 },
    { id: 'news_3', title: 'Global Semiconductor Sales Surge 24% Driven by Data Center Boom', category: 'Business', author: 'Bloomberg', status: 'Published', likes: 2150 },
    { id: 'news_4', title: 'India Wins T20 World Cup Final in Thrilling Last-Over Finish', category: 'Cricket', author: 'ESPN', status: 'Published', likes: 18450 },
  ]);

  return (
    <Box sx={{ p: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Box>
          <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff' }}>
            News Article Management
          </Typography>
          <Typography variant="body2" sx={{ color: '#94A3B8' }}>
            Publish, edit, feature, and manage AI news reels.
          </Typography>
        </Box>
        <Button variant="contained" startIcon={<Plus size={18} />} sx={{ borderRadius: '10px' }}>
          Create Manual News
        </Button>
      </Box>

      <TableContainer component={Paper} sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell sx={{ color: '#94A3B8', fontWeight: 'bold' }}>Title</TableCell>
              <TableCell sx={{ color: '#94A3B8', fontWeight: 'bold' }}>Category</TableCell>
              <TableCell sx={{ color: '#94A3B8', fontWeight: 'bold' }}>Source</TableCell>
              <TableCell sx={{ color: '#94A3B8', fontWeight: 'bold' }}>Likes</TableCell>
              <TableCell sx={{ color: '#94A3B8', fontWeight: 'bold' }}>Status</TableCell>
              <TableCell sx={{ color: '#94A3B8', fontWeight: 'bold' }}>Actions</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {articles.map((row) => (
              <TableRow key={row.id}>
                <TableCell sx={{ color: '#fff', fontWeight: 600 }}>{row.title}</TableCell>
                <TableCell><Chip label={row.category} size="small" color="primary" /></TableCell>
                <TableCell sx={{ color: '#94A3B8' }}>{row.author}</TableCell>
                <TableCell sx={{ color: '#fff' }}>{row.likes}</TableCell>
                <TableCell><Chip label={row.status} size="small" color="success" /></TableCell>
                <TableCell>
                  <IconButton size="small" sx={{ color: '#6366F1' }}><Eye size={18} /></IconButton>
                  <IconButton size="small" sx={{ color: '#06B6D4' }}><Edit size={18} /></IconButton>
                  <IconButton size="small" sx={{ color: '#F43F5E' }}><Trash2 size={18} /></IconButton>
                </TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};
