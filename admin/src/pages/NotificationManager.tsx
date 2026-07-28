import React, { useState } from 'react';
import { Box, Typography, Button, TextField, Card, CardContent } from '@mui/material';
import { Send } from 'lucide-react';

export const NotificationManager: React.FC = () => {
  const [title, setTitle] = useState('');
  const [message, setMessage] = useState('');

  const handleSend = () => {
    alert(`Push Notification Scheduled: "${title}"`);
    setTitle('');
    setMessage('');
  };

  return (
    <Box sx={{ p: 4 }}>
      <Typography variant="h4" sx={{ fontWeight: 'bold', color: '#fff', mb: 1 }}>Push Notifications</Typography>
      <Typography variant="body2" sx={{ color: '#94A3B8', mb: 4 }}>Schedule breaking news & category notifications</Typography>

      <Card sx={{ backgroundColor: '#1E293B', border: '1px solid #334155', maxWidth: 600 }}>
        <CardContent sx={{ display: 'flex', flexDirection: 'column', gap: 2 }}>
          <TextField label="Notification Title" fullWidth value={title} onChange={(e) => setTitle(e.target.value)} />
          <TextField label="Notification Body" fullWidth multiline rows={3} value={message} onChange={(e) => setMessage(e.target.value)} />
          <Button variant="contained" startIcon={<Send size={18} />} onClick={handleSend}>Send Broadcast Push</Button>
        </CardContent>
      </Card>
    </Box>
  );
};
