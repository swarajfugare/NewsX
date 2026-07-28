import React from 'react';
import { Drawer, List, ListItem, ListItemButton, ListItemIcon, ListItemText, Typography, Box } from '@mui/material';
import { LayoutDashboard, Newspaper, Category, Rss, Cpu, Users, Bell, LogOut } from 'lucide-react';
import { useNavigate, useLocation } from 'react-router-dom';

const drawerWidth = 260;

const navItems = [
  { text: 'Dashboard', icon: <LayoutDashboard size={20} />, path: '/' },
  { text: 'News Manager', icon: <Newspaper size={20} />, path: '/news' },
  { text: 'Categories', icon: <Category size={20} />, path: '/categories' },
  { text: 'RSS Feeds', icon: <Rss size={20} />, path: '/rss' },
  { text: 'AI Engine Monitor', icon: <Cpu size={20} />, path: '/ai' },
  { text: 'Users & Roles', icon: <Users size={20} />, path: '/users' },
  { text: 'Push Notifications', icon: <Bell size={20} />, path: '/notifications' },
];

export const Sidebar: React.FC = () => {
  const navigate = useNavigate();
  const location = useLocation();

  const handleLogout = () => {
    localStorage.removeItem('newsx_admin_token');
    navigate('/login');
  };

  return (
    <Drawer
      variant="permanent"
      sx={{
        width: drawerWidth,
        flexShrink: 0,
        '& .MuiDrawer-paper': {
          width: drawerWidth,
          boxSizing: 'border-box',
          backgroundColor: '#0F172A',
          borderRight: '1px solid #334155',
        },
      }}
    >
      <Box sx={{ p: 3, display: 'flex', alignItems: 'center', gap: 1.5 }}>
        <Box
          sx={{
            width: 38,
            height: 38,
            borderRadius: '10px',
            background: 'linear-gradient(135deg, #6366F1 0%, #8B5CF6 100%)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            color: '#fff',
            fontWeight: 'bold',
          }}
        >
          ⚡
        </Box>
        <Typography variant="h6" sx={{ fontWeight: 'bold', color: '#fff', letterSpacing: '-0.5px' }}>
          NewsX Admin
        </Typography>
      </Box>

      <List sx={{ px: 2 }}>
        {navItems.map((item) => {
          const active = location.pathname === item.path;
          return (
            <ListItem key={item.text} disablePadding sx={{ mb: 1 }}>
              <ListItemButton
                onClick={() => navigate(item.path)}
                sx={{
                  borderRadius: '10px',
                  backgroundColor: active ? 'rgba(99, 102, 241, 0.15)' : 'transparent',
                  color: active ? '#6366F1' : '#94A3B8',
                  '&:hover': {
                    backgroundColor: 'rgba(99, 102, 241, 0.08)',
                    color: '#fff',
                  },
                }}
              >
                <ListItemIcon sx={{ color: active ? '#6366F1' : '#94A3B8', minWidth: 40 }}>
                  {item.icon}
                </ListItemIcon>
                <ListItemText primary={item.text} primaryTypographyProps={{ fontSize: 14, fontWeight: active ? 700 : 500 }} />
              </ListItemButton>
            </ListItem>
          );
        })}
      </List>

      <Box sx={{ mt: 'auto', p: 2 }}>
        <ListItemButton onClick={handleLogout} sx={{ borderRadius: '10px', color: '#F43F5E' }}>
          <ListItemIcon sx={{ color: '#F43F5E', minWidth: 40 }}>
            <LogOut size={20} />
          </ListItemIcon>
          <ListItemText primary="Logout" primaryTypographyProps={{ fontSize: 14, fontWeight: 600 }} />
        </ListItemButton>
      </Box>
    </Drawer>
  );
};
