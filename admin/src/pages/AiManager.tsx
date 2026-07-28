import React from 'react';
import { Box, Typography, Card, CardContent, Grid, Chip } from '@mui/material';

export const AiManager: React.FC = () => {
  return (
    <Box sx={{ p: 4 }}>
      <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff', mb: 1 }}>
        Gemini AI Engine Telemetry
      </Typography>
      <Typography variant="body2" sx={{ color: '#94A3B8', mb: 4 }}>
        Monitor token consumption, synthesis queues, and response latency.
      </Typography>

      <Grid container spacing={3}>
        <Grid item xs={12} sm={4}>
          <Card sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
            <CardContent>
              <Typography variant="subtitle2" sx={{ color: '#94A3B8' }}>AI Requests Today</Typography>
              <Typography variant="h3" sx={{ color: '#fff', fontWeight: 'bold', my: 1 }}>4,120</Typography>
              <Chip label="100% Success Rate" color="success" size="small" />
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={4}>
          <Card sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
            <CardContent>
              <Typography variant="subtitle2" sx={{ color: '#94A3B8' }}>Estimated API Cost</Typography>
              <Typography variant="h3" sx={{ color: '#06B6D4', fontWeight: 'bold', my: 1 }}>$0.42</Typography>
              <Chip label="Gemini 1.5 Flash Model" color="primary" size="small" />
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={4}>
          <Card sx={{ backgroundColor: '#1E293B', border: '1px solid #334155' }}>
            <CardContent>
              <Typography variant="subtitle2" sx={{ color: '#94A3B8' }}>Avg AI Latency</Typography>
              <Typography variant="h3" sx={{ color: '#10B981', fontWeight: 'bold', my: 1 }}>420 ms</Typography>
              <Chip label="Ultra Fast Synthesis" color="success" size="small" />
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};
