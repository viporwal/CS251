PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE employees (id integer primary key, name text);
INSERT INTO "employees" VALUES(1,'Derek Banas');
INSERT INTO "employees" VALUES(2,'Tushar');
INSERT INTO "employees" VALUES(3,'Raghukul Raman');
INSERT INTO "employees" VALUES(4,'Suds');
INSERT INTO "employees" VALUES(5,'Anas');
COMMIT;
