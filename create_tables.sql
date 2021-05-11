CREATE TABLE IF NOT EXISTS products (
  "id" INTEGER PRIMARY KEY,
  "name" TEXT NOT NULL DEFAULT '',
  "slogan" TEXT NOT NULL DEFAULT '',
  "description" TEXT NOT NULL DEFAULT '',
  "category" TEXT NOT NULL DEFAULT '',
  "default_price" MONEY CHECK ("default_price" >= '0') DEFAULT '0'
);

CREATE TABLE IF NOT EXISTS features (
  "id" INTEGER PRIMARY KEY,
  "product_id" INTEGER NOT NULL,
  "feature" TEXT NOT NULL DEFAULT '',
  "value" TEXT NOT NULL DEFAULT '',
  FOREIGN KEY ("product_id") REFERENCES "products" ("id")
);

CREATE TABLE IF NOT EXISTS styles (
  "id" INTEGER PRIMARY KEY,
  "product_id" INTEGER NOT NULL,
  "name" TEXT NOT NULL DEFAULT '',
  "sale_price" MONEY CHECK ("sale_price" >= '0') DEFAULT '0',
  "original_price" MONEY CHECK ("original_price" >= '0') DEFAULT '0',
  "default_style" BOOLEAN NOT NULL DEFAULT false,
  FOREIGN KEY ("product_id") REFERENCES "products" ("id")
);

CREATE TABLE iF NOT EXISTS photos (
  "id" INTEGER PRIMARY KEY,
  "style_id" INTEGER NOT NULL,
  "url" TEXT NOT NULL DEFAULT 'https://files.catbox.moe/a61ls9.png',
  "thumbnail_url" TEXT NOT NULL DEFAULT 'https://files.catbox.moe/a61ls9.png',
  FOREIGN KEY ("style_id") REFERENCES "styles" ("id")
);

CREATE TABLE IF NOT EXISTS skus (
  "id" INTEGER PRIMARY KEY,
  "style_id" INTEGER NOT NULL,
  "quantity" INTEGER NOT NULL DEFAULT 0,
  "size" TEXT NOT NULL DEFAULT 'One Size',
  FOREIGN KEY ("style_id") REFERENCES "styles" ("id")
);

CREATE TABLE IF NOT EXISTS related (
  "id" INTEGER PRIMARY KEY,
  "current_product_id" INTEGER NOT NULL,
  "related_product_id" INTEGER NOT NULL,
  FOREIGN KEY ("current_product_id") REFERENCES "products" ("id"),
  FOREIGN KEY ("related_product_id") REFERENCES "products" ("id")
);


--ALTER TABLE "features"
--  ADD CONSTRAINT "product_id"
--  FOREIGN KEY ("product_id")
--  REFERENCES "products" ("id");
--
--ALTER TABLE "styles"
--  ADD CONSTRAINT "product_id"
--  FOREIGN KEY ("product_id")
--  REFERENCES "products" ("id");
--
--ALTER TABLE "photos"
--  ADD CONSTRAINT "style_id"
--  FOREIGN KEY ("style_id")
--  REFERENCES "styles" ("id");
--
--ALTER TABLE "skus"
--  ADD CONSTRAINT "style_id"
--  FOREIGN KEY ("style_id")
--  REFERENCES "styles" ("id");
--
--ALTER TABLE "related"
--  ADD CONSTRAINT "product_id"
--  FOREIGN KEY ("product_id")
--  REFERENCES "products" ("id");
--
--ALTER TABLE "related"
--  ADD CONSTRAINT "related_id"
--  FOREIGN KEY ("related_id")
--  REFERENCES "products" ("id");

-- PRODUCTS
-- could not use many uniques here since many products fields are repetitive
-- default_price can go up to 50000 (infinity stones)
-- line 180, product_id 179, has desc in slogan place, 5 instead of 6 fields
-- the ones with 5 columns are all missing slogan
-- name repeats "Diamond Romper", "Consuelo Coat", "Vladimir Coat", "Cleora Slacks", "Hassan Skirt"
--FORCE QUOTE ("slogan","description","category"

-- FEATURES

-- STYLES
--  NOT UNIQ!!!! -> FOREIGN KEY ("original_price") REFERENCES "products" ("default_price")
-- in csv default is 0 or 1, but in products api true/false
-- nulls for name in csv

-- PHOTOS
-- some url and thumbnail_url start with uhttps://

-- SKUS
-- size varies, is it all text? no, some are unquoted numbers, some have decimals
