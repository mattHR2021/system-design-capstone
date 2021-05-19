const express = require('express');
const router = express.Router();

const { Pool } = require('pg');
const pool = new Pool({
  host: 'localhost',
  database: 'sdc',
  user: 'postgres',
  password: 'password',
  port: 5432
});
pool.on('error', (err, client) => {
  console.error('Unexpected error on idle client', err);
  process.exit(-1);
})

router.route('/')
  .get(async (req, res) => {
    let limit = req.query.count || '5';
    let offset = req.query.page
      ? ((Number(req.query.page - 1)) * (Number(limit))).toString()
      : '1';
    let q = `SELECT * FROM "products" LIMIT ${limit} OFFSET ${offset}`;
    let client = await pool.connect();
    try {
      let qRes = await client.query(q);
      res.send(qRes.rows)
    } catch (err) {
      res.send(err);
    } finally {
      client.release();
      res.end();
    }
  });

router.param('product_id', (req, res, next) => {
  req.id = req.params.product_id;
  next();
})

router.route('/:product_id')
  .get(async (req, res) => {
    let q1 = `SELECT * FROM "products" WHERE "id"=${req.id}`;
    let q2 = `SELECT "feature","value" FROM "features" WHERE "product_id"=${req.id}`;
    let client = await pool.connect();
    try {
      let qRes1 = await client.query(q1);
      let qRes2 = await client.query(q2);
      let qRes = qRes1.rows[0];
      qRes = {
        ...qRes,
        features: qRes2.rows
      }
      res.send(qRes)
    } finally {
      client.release();
      res.end();
    }
  });


router.route('/:product_id/styles')
  .get(async (req, res) => {
    let q1 = `SELECT "id" AS "style_id","name","original_price","sale_price","default_style" FROM "styles" WHERE "product_id"=${req.id}`;
    let client = await pool.connect();
    try {
      let qRes1 = await client.query(q1);
      qRes = {
        product_id: req.id,
        results: qRes1.rows,
        photos: [],
        skus: {}
      }
      let photosArr = [];
      let skusObj = {};
      for await (let item of qRes.results) {
        let q2 = `SELECT "thumbnail_url","url" FROM "photos" WHERE "style_id"=${item.style_id}`;
        let q3 = `SELECT "id","quantity","size" FROM "skus" WHERE "style_id"=${item.style_id}`;
        let qRes2 = await Promise.resolve(client.query(q2));
        let qRes3 = await Promise.resolve(client.query(q3));
        console.log('qRes2 rows:',qRes2.rows);
        //qRes.photos.push(qRes2.rows);
        qRes.skus[qRes3.rows[0].id] = {
          quantity: qRes3.rows[0].quantity,
          size: qRes3.rows[0].size
        }
      }
      res.send(qRes);
    } finally {
      client.release();
      res.end();
    }
  });

router.route('/:product_id/related')
  .get(async (req, res) => {
    let q = `SELECT "related_product_id" FROM "related" WHERE "current_product_id"=${req.id}`;
    let client = await pool.connect();
    try {
      let result = await client.query(q);
      let related_ids = [];
      for (const obj of result.rows) {
        related_ids.push(obj.related_product_id);
      }
      res.send(related_ids)
    } finally {
      client.release();
      res.end();
    }
  });

module.exports = router;