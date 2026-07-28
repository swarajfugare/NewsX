import { createTheme } from '@mui/material/styles';

export const darkTheme = createTheme({
  palette: {
    mode: 'dark',
    background: {
      default: '#0F172A',
      paper: '#1E293B',
    },
    primary: {
      main: '#6366F1',
    },
    secondary: {
      main: '#06B6D4',
    },
    error: {
      main: '#F43F5E',
    },
    warning: {
      main: '#F59E0B',
    },
    success: {
      main: '#10B981',
    },
  },
  typography: {
    fontFamily: '"Plus Jakarta Sans", sans-serif',
  },
  shape: {
    borderRadius: 12,
  },
});
