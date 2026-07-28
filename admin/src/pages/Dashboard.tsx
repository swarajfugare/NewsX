import React from 'react';
import { Grid, Card, CardContent, Typography, Box, Chip } from '@mui/material';
import { Users, Newspaper, Bookmark, Share2, Cpu, Database, Activity, CheckCircle2 } from 'lucide-react';

export const Dashboard: React.FC = () => {
  const stats = [
    { title: 'Total Registered Users', value: '24,850', icon: <Users color="#6366F1" />, growth: '+12% this week' },
    { title: 'Daily Active Users (DAU)', value: '8,420', icon: <Activity color="#06B6D4" />, growth: '+18% today' },
    { title: 'Total News Articles', value: '4,120', icon: <Newspaper color="#10B981" />, growth: '+150 today' },
    { title: 'Bookmarks & Shares', value: '18,940', icon: <Bookmark color="#F59E0B" />, growth: '+640 today' },
  ];

  const systemHealth = [
    { label: 'Hostinger Node.js Server', status: 'HEALTHY', color: 'success' },
    { label: 'MySQL Database Connection Pool', status: 'ONLINE', color: 'success' },
    { label: 'Google Gemini 1.5 AI Pipeline', status: 'ACTIVE', color: 'success' },
    { label: 'Node-Cron Background Ingestion', status: 'RUNNING', color: 'success' },
  ];

  return (
    <Box sx={{ p: 4 }}>
      <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff', mb: 1 }}>
        Dashboard Overview
      </Typography>
      <Typography variant="body2" sx={{ color: '#94A3B8', mb: 4 }}>
        Real-time telemetry, user retention analytics, and AI ingestion performance.
      </Typography>

      <Grid container spacing={3} sx={{ mb: 4 }}>
        {stats.map((stat, idx) => (
          <Grid item xs={12} sm={6} md={3} key={idx}>
            <Card sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
              <CardContent>
                <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
                  <Typography variant="caption" sx={{ color: '#94A3B8', fontWeight: 600 }}>
                    {stat.title}
                  </Typography>
                  <Box sx={{ p: 1, borderRadius: '10px', backgroundColor: 'rgba(255,255,255,0.05)' }}>
                    {stat.icon}
                  </Box>
                </Box>
                <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff', mb: 1 }}>
                  {stat.value}
                </Typography>
                <Chip label={stat.growth} size="small" color="success" sx={{ fontSize: 11, fontWeight: 700 }} />
              </CardContent>
            </Card>
          </Grid>
        ))}
      </Grid>

      {/* System Health Telemetry */}
      <Card sx={{ backgroundColor: '#1E293B', border: '1px solid #334155', p: 3 }}>
        <Typography variant="h6" sx={{ color: '#fff', fontWeight: 'bold', mb: 2 }}>
          System Health Telemetry
        </Typography>
        <Grid container spacing={2}>
          {systemHealth.map((item, index) => (
            <Grid item xs={12} sm={6} md={3} key={index}>
              <Box
                sx={{
                  p: 2,
                  borderRadius: 2,
                  backgroundColor: 'rgba(255,255,255,0.03)',
                  border: '1px solid #334155',
                  display: 'flex',
                  alignItems: 'center',
                  gap: 1.5,
                }}
              >
                <CheckCircle2 color="#10B981" size={24} />
                <Box>
                  <Typography variant="subtitle2" sx={{ color: '#fff', fontWeight: 600 }}>
                    {item.label}
                  </Typography>
                  <Typography variant="caption" sx={{ color: '#10B981', fontWeight: 700 }}>
                    {item.status}
                  </Typography>
                </Box>
              </Box>
            </Grid>
          ))}
        </Grid>
      </Card>
    </Box>
  );
};
