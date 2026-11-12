const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;
const APP_ENV = process.env.APP_ENV || 'local';

app.get('/', (req, res) => {
  res.send(`<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>CI/CD Pipeline Demo</title>
<style>
  body{margin:0;min-height:100vh;display:flex;align-items:center;justify-content:center;
       font-family:system-ui,Arial,sans-serif;background:linear-gradient(135deg,#1f3a5f,#3b6ea5);color:#1b1b1b}
  .card{background:#fff;border-radius:14px;padding:40px 48px;max-width:560px;box-shadow:0 10px 30px rgba(0,0,0,.25)}
  h1{margin:0 0 12px;font-size:28px}
  .badge{display:inline-block;background:#e6f4ea;color:#137333;padding:4px 12px;border-radius:999px;font-size:14px;margin-bottom:16px}
  p{margin:6px 0;color:#444}
</style></head>
<body><div class="card">
  <span class="badge">Version 2 - deployed automatically</span>
  <h1>Hello from the CI/CD pipeline!</h1>
  <p>Environment: ${APP_ENV}</p>
  <p>Jenkins built, tested and deployed this container using Terraform.</p>
</div></body></html>`);
});

app.get('/health', (req, res) => {
  res.json({ status: 'ok', env: APP_ENV });
});

if (require.main === module) {
  app.listen(PORT, () => console.log(`App listening on port ${PORT}`));
}

module.exports = app;
