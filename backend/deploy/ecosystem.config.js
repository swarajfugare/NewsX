module.exports = {
  apps: [
    {
      name: 'newsx-backend',
      script: 'src/server.js',
      instances: 'max',
      exec_mode: 'cluster',
      env_production: {
        NODE_ENV: 'production',
        PORT: 5000,
      },
      max_memory_restart: '500M',
      restart_delay: 4000,
    },
    {
      name: 'newsx-cron-worker',
      script: 'src/cron/newsCron.js',
      instances: 1,
      exec_mode: 'fork',
      env_production: {
        NODE_ENV: 'production',
      },
    },
  ],
};
