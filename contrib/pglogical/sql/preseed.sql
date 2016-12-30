-- Indirection for connection strings
CREATE OR REPLACE FUNCTION public.pglogical_regress_variables(
    OUT provider_dsn text,
    OUT subscriber_dsn text
    ) RETURNS record LANGUAGE SQL AS $f$
SELECT
    current_setting('pglogical.provider_dsn'),
    current_setting('pglogical.subscriber_dsn')
$f$;

SELECT * FROM pglogical_regress_variables()
\gset

/*
 * Tests to ensure that objects/data that exists pre-clone is successfully
 * cloned. The results are checked, after the clone, in preseed_check.sql.
 */
\c :provider_dsn
CREATE SEQUENCE some_local_seq;
CREATE TABLE some_local_tbl(id serial primary key, key text unique not null, data text);
INSERT INTO some_local_tbl(key, data) VALUES('key1', 'data1');
INSERT INTO some_local_tbl(key, data) VALUES('key2', NULL);
INSERT INTO some_local_tbl(key, data) VALUES('key3', 'data3');
CREATE TABLE some_local_tbl1(id serial, key text unique not null, data text);
INSERT INTO some_local_tbl1(key, data) VALUES('key1', 'data1');
INSERT INTO some_local_tbl1(key, data) VALUES('key2', NULL);
INSERT INTO some_local_tbl1(key, data) VALUES('key3', 'data3');
CREATE TABLE some_local_tbl2(id serial, key text, data text);
INSERT INTO some_local_tbl2(key, data) VALUES('key1', 'data1');
INSERT INTO some_local_tbl2(key, data) VALUES('key2', NULL);
INSERT INTO some_local_tbl2(key, data) VALUES('key3', 'data3');
CREATE TABLE some_local_tbl3(id integer, key text, data text);
INSERT INTO some_local_tbl3(key, data) VALUES('key1', 'data1');
INSERT INTO some_local_tbl3(key, data) VALUES('key2', NULL);
INSERT INTO some_local_tbl3(key, data) VALUES('key3', 'data3');

/*
 * Make sure that the pglogical_regress_variables function exists both on
 * provider and subscriber since the original connection might have been
 * to completely different database.
 */
CREATE OR REPLACE FUNCTION public.pglogical_regress_variables(
    OUT provider_dsn text,
    OUT subscriber_dsn text
    ) RETURNS record LANGUAGE SQL AS $f$
SELECT
    current_setting('pglogical.provider_dsn'),
    current_setting('pglogical.subscriber_dsn')
$f$;

\c :subscriber_dsn
CREATE OR REPLACE FUNCTION public.pglogical_regress_variables(
    OUT provider_dsn text,
    OUT subscriber_dsn text
    ) RETURNS record LANGUAGE SQL AS $f$
SELECT
    current_setting('pglogical.provider_dsn'),
    current_setting('pglogical.subscriber_dsn')
$f$;