COPY products ("id","name","slogan","description","category","default_price")
  FROM '/tmp/product.csv'
  WITH (FORMAT CSV);

COPY styles ("id","product_id","name","sale_price","original_price","default_style")
  FROM '/tmp/styles-cleaned.csv'
  WITH (FORMAT CSV);

COPY features ("id", "product_id","feature","value")
  FROM '/tmp/features.csv'
  WITH (FORMAT CSV);

COPY photos ("id","style_id","url","thumbnail_url")
  FROM '/tmp/photos.csv'
  WITH (FORMAT CSV);

COPY skus ("id","style_id","size","quantity")
  FROM '/tmp/skus.csv'
  WITH (FORMAT CSV);

COPY related ("id","current_product_id","related_product_id")
  FROM '/tmp/related-cleaned.csv'
  WITH (FORMAT CSV);

--COPY products ("id","name","slogan","description","category","default_price")
--  FROM '/tmp/product3.csv'
--  DELIMITER ','
--  FORCE NOT NULL "slogan"
--  CSV HEADER;

--^^^FORCE QUOTE ("slogan","description","category"

--COPY features ("product_id","feature","value")
--  FROM '/tmp/features-no_nonexistent_products.csv'
--  CSV HEADER;

--COPY styles ("product_id","name","sale_price","original_price","default_style")
--  FROM '/tmp/styles-no_id-5col-names-0money.csv'
--  CSV HEADER;

--COPY photos ("style_id","url","thumbnail_url")
--  FROM '/tmp/photos-no_id-no_uhttps.csv'
--  CSV HEADER;