# Домашнее задание к занятию 4. «PostgreSQL»

## Задача 1

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:

- вывода списка БД,
```
psql> \l и расширенный вывод \l+
```
- подключения к БД,
```
psql> \c <ИМЯ_БАЗЫДАННЫХ> и полный вид \c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
```
- вывода списка таблиц,
```
psql> \dt и расширенный вывод \dt+
```
- вывода описания содержимого таблиц,
```
psql> \d <ИМЯ_ТАБЛИЦЫ>
```
- выхода из psql.
```
psql> \q
```

## Задача 2

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления, и полученный результат.

``` sql
test_database=# \dt

         List of relations
 Schema |  Name  | Type  |  Owner
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE orders;
ANALYZE

test_database=# SELECT schemaname, tablename, attname, avg_width FROM pg_stats
  WHERE avg_width=(SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders');

 schemaname | tablename | attname | avg_width
------------+-----------+---------+-----------
 public     | orders    | title   |        16
(1 row)
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам как успешному выпускнику курсов DevOps в Нетологии предложили
провести разбиение таблицы на 2: шардировать на orders_1 - price>499 и orders_2 - price<=499.

Предложите SQL-транзакцию для проведения этой операции.
``` sql
test_database=# BEGIN;
BEGIN

test_database=*# CREATE TABLE public.orders_new (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0 NOT NULL
) PARTITION BY RANGE (price);
CREATE TABLE

test_database=*# ALTER TABLE orders RENAME TO orders_archive;
ALTER TABLE

test_database=*# ALTER TABLE orders_new RENAME to orders;
ALTER TABLE

test_database=*# CREATE TABLE orders_2 PARTITION OF orders
    FOR VALUES FROM (MINVALUE) TO (500);
CREATE TABLE

test_database=*# CREATE TABLE orders_1 PARTITION OF orders
    FOR VALUES FROM (500) TO (MAXVALUE);
CREATE TABLE

test_database=*# INSERT INTO orders (id, title, price)
  SELECT id, title, price FROM orders_archive;
INSERT 0 8

test_database=*# DROP TABLE orders_archive;
DROP TABLE

test_database=*# ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (id,price);
ALTER TABLE

test_database=*# COMMIT;
COMMIT
```

**<em>Можно ли было изначально исключить ручное разбиение при проектировании таблицы orders?</em>**
Нативной функции по разбиению таблицы на портиции в PostgreSQL нет, их всё равно надо будет
создать вручную.

## Задача 4

Используя утилиту `pg_dump`, создайте бекап БД `test_database`.

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?  

### Для секционированной таблицы
``` sql
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0 NOT NULL,
    UNIQUE (id,price)
)
PARTITION BY RANGE (price);
```

### Для таблицы без партиций
``` sql
CREATE TABLE public.orders (
    id integer NOT NULL UNIQUE,
    title character varying(80) NOT NULL,
    price integer DEFAULT 0
);
```

---