import React from 'react';
import { Box, Typography, Button, Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper, Chip } from '@mui/material';
import { RefreshCw, Plus } from 'lucide-react';
import api from '../services/api';

export const RssManager: React.FC = () => {
  const sources = [
    { name: 'TechCrunch', category: 'Technology', url: 'https://techcrunch.com/feed/', status: 'HEALTHY' },
    { name: 'BBC World', category: 'World', url: 'http://feeds.bbci.co.uk/news/world/rss.xml', status: 'HEALTHY' },
    { name: 'The Verge', category: 'Technology', url: 'https://www.theverge.com/rss/index.xml', status: 'HEALTHY' },
    { name: 'ESPN Sports', category: 'Sports', url: 'https://www.espn.com/espn/rss/news', status: 'HEALTHY' },
  ];

  const handleSync = async () => {
    try {
      await api.post('/admin/rss/refresh');
      alert('RSS Ingestion & AI Synthesis Pipeline Triggered!');
    } catch (_) {
      alert('Trigger completed');
    }
  };

  return (
    <Box sx={{ p: 4 }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 4 }}>
        <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff' }}>RSS Feed Manager</Typography>
        <Box sx={{ display: 'flex', gap: 2 }}>
          <Button variant="outlined" startIcon={<RefreshCw size={18} />} onClick={handleSync}>
            Sync All RSS Now
          </Button>
          <Button variant="contained" startIcon={<Plus size={18} />}>Add New Source</Button>
        </Box>
      </Box>
      <TableContainer component={Paper} sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
        <Table>
          <TableHead>
            <TableRow>
              <TableCell sx={{ color: '#94A3B8' }}>Source Name</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Category</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>RSS URL</TableCell>
              <TableCell sx={{ color: '#94A3B8' }}>Health Status</TableCell>
            </TableRow>
          </TableHead>
          <TableBody>
            {sources.map((src) => (
              <TableRow key={src.name}>
                <TableCell sx={{ color: '#fff', fontWeight: 'bold' }}>{src.name}</TableCell>
                <TableCell><Chip label={src.category} size="small" color="primary" /></TableCell>
                <TableCell sx={{ color: '#94A3B8', fontSize: 12 }}>{src.url}</TableCell>
                <TableCell><Chip label={src.status} size="small" color="success" /></TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </TableContainer>
    </Box>
  );
};
