const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;
const APP_ENV = process.env.APP_ENV || 'local';

app.get('/', (req, res) => {
  res.send(`<h1>Hello from the CI/CD pipeline!</h1><p>Environment: ${APP_ENV}</p>`);
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', env: APP_ENV });
});

if (require.main === module) {
  app.listen(PORT, () => console.log(`App listening on port ${PORT}`));
}

module.exports = app;
