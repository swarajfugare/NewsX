import React from 'react';
import { AppBar, Toolbar, Typography, Avatar, Box, Chip } from '@mui/material';

export const Header: React.FC = () => {
  return (
    <AppBar
      position="static"
      elevation={0}
      sx={{
        backgroundColor: '#1E293B',
        borderBottom: '1px solid #334155',
      }}
    >
      <Toolbar sx={{ justifyContent: 'space-between' }}>
        <Typography variant="subtitle1" sx={{ color: '#94A3B8', fontWeight: 600 }}>
          Production Management Console • Phase 6
        </Typography>

        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2 }}>
          <Chip label="Super Admin" color="primary" size="small" sx={{ fontWeight: 'bold' }} />
          <Avatar
            alt="Admin Avatar"
            src="https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200&auto=format&fit=crop"
            sx={{ width: 36, height: 36 }}
          />
        </Box>
      </Toolbar>
    </AppBar>
  );
};
