const express = require('express');
const cors = require('cors');
const chalk = require('chalk');

// SETUP =================================================================== //
// setup Expressjs server instance
let app = express();
let port = 9000;
app.listen(port, () => { console.log(`server listening on port ${port}`); });

// root middleware ========================================================= //
// EVERY REQ
//app.use(express.static('./public'));
app.use(cors());
app.use(express.json());

// REQ methods to root (not already handled by static serving of /public)
app.all('/', (req, res) => { res.end(`cannot ${req.method} to root`) });

// logger hits first in chain (on all REQs)
const getDuration = (start) => {
  const NS_PER_SEC = 1e9;
  const NS_TO_MS = 1e6;
  const diff = process.hrtime(start);
  return ((diff[0] * NS_PER_SEC + diff[1]) / NS_TO_MS);
}

app.use((req, res, next) => {
  const start = process.hrtime();
  let date_time = new Date().toISOString().slice(0.,19);
  let method = req.method;
  let url = req.url;
  let body = '';
  if (Object.keys(req.body).length) { body = req.body; }
  let status = chalk.white(res.statusCode);
  if (Number(status) >= 200) { status = chalk.green(res.statusCode); }
  else if (Number(status) >= 400) { status = chalk.yellow(res.statusCode); }
  else if (Number(status) >= 500) { status = chalk.red(res.statusCode); }
  const duration = getDuration(start);
  console.log(`[${date_time}] ${method}:${url} ${status} ${duration}ms`);
  next();
});

// routes =================================================================== //
// prepend /api/ ???
app.use('/api/products', require('./routes/products.js'));

module.exports = app;
