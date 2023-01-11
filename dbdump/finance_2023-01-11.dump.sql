----
-- phpLiteAdmin database dump (https://www.phpliteadmin.org/)
-- phpLiteAdmin version: 1.9.9-dev
-- Exported: 4:24am on January 11, 2023 (UTC)
-- database file: /workspaces/112088658/pset9/finance/finance.db
----
BEGIN TRANSACTION;

----
-- Table structure for users
----
CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, username TEXT NOT NULL, hash TEXT NOT NULL, cash NUMERIC NOT NULL DEFAULT 10000.00);

----
-- Data dump for users, a total of 1 rows
----
INSERT INTO "users" ("id","username","hash","cash") VALUES ('1','Paul','pbkdf2:sha256:260000$00C6RmRMl9cdxDzL$a585829f300e0f45d7e50cecbb880fe700496c7a4bde917a13180300d7e54f20','8328.37');

----
-- Table structure for transactions
----
CREATE TABLE transactions (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id INTEGER NOT NULL, datetime TEXT NOT NULL, symbol text NOT NULL, amount INTEGER NOT NULL, ppu FLOAT NOT NULL);

----
-- Data dump for transactions, a total of 7 rows
----
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('1','1','2022-12-31 03:43:08','VOO','2','351.34');
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('2','1','2022-12-31 03:59:10','GOOGL','2','88.23');
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('4','1','2022-12-31 04:01:26','VOO','10','351.34');
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('7','1','2023-01-01 09:59:31','VOO','3','351.34');
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('8','1','2023-01-01 10:02:07','GOOGL','1','88.23');
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('9','1','2023-01-01 11:05:38','VOO','-1','351.34');
INSERT INTO "transactions" ("id","user_id","datetime","symbol","amount","ppu") VALUES ('10','1','2023-01-01 11:06:37','VOO','-11','351.34');

----
-- Table structure for assets
----
CREATE TABLE assets (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, user_id INTEGER NOT NULL, symbol text NOT NULL, amount INTEGER NOT NULL);

----
-- Data dump for assets, a total of 2 rows
----
INSERT INTO "assets" ("id","user_id","symbol","amount") VALUES ('1','1','VOO','3');
INSERT INTO "assets" ("id","user_id","symbol","amount") VALUES ('2','1','GOOGL','3');

----
-- structure for index username on table users
----
CREATE UNIQUE INDEX username ON users (username);

----
-- structure for index transactions_id on table transactions
----
CREATE UNIQUE INDEX transactions_id ON transactions(id)
;

----
-- structure for index user_id on table users
----
CREATE UNIQUE INDEX user_id ON users(id);

----
-- structure for index asset_symbol on table assets
----
CREATE INDEX 'asset_symbol' ON "assets" ("symbol" ASC);

----
-- structure for index user_id_index on table assets
----
CREATE INDEX 'user_id_index' ON "assets" ("user_id" ASC);
COMMIT;
