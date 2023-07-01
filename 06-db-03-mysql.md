# Домашнее задание к занятию 3. «MySQL»

## Задача 1

**<em>Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД.</em>**
```
mysql> status

Server version:         8.0.33 MySQL Community Server - GPL
```

**<em>Подключитесь к восстановленной БД и получите список таблиц из этой БД. Приведите в ответе количество записей с `price` > 300.</em>**
``` sql
mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.00 sec)

mysql> SELECT COUNT(*) FROM orders WHERE price>300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)
```

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:

- плагин авторизации mysql_native_password
- срок истечения пароля — 180 дней 
- количество попыток авторизации — 3 
- максимальное количество запросов в час — 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James".

Предоставьте привелегии пользователю `test` на операции SELECT базы `test_db`.
    
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю `test` и 
**приведите в ответе к задаче**.

``` sql
mysql> CREATE USER 'test'
    ->   IDENTIFIED WITH mysql_native_password BY 'test-pass'
    ->   WITH MAX_QUERIES_PER_HOUR 100
    ->   PASSWORD EXPIRE INTERVAL 180 DAY
    ->   FAILED_LOGIN_ATTEMPTS 3
    ->   ATTRIBUTE '{"LastName":"Pretty", "FirstName": "James"}';
Query OK, 0 rows affected (0.00 sec)

mysql> GRANT
    ->   SELECT
    ->   ON test_db.*
    ->   TO 'test';
Query OK, 0 rows affected (0.01 sec)

mysql> select * from INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE user='test';
+------+------+----------------------------------------------+
| USER | HOST | ATTRIBUTE                                    |
+------+------+----------------------------------------------+
| test | %    | {"LastName": "Pretty", "FirstName": "James"} |
+------+------+----------------------------------------------+
1 row in set (0.00 sec)
```

## Задача 3

**<em>Исследуйте, какой `engine` используется в таблице БД `test_db` и приведите в ответе.</em>**
``` sql
mysql> SELECT TABLE_NAME,
    ->        ENGINE
    -> FROM   information_schema.TABLES
    -> WHERE  TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.01 sec)
```

**<em>Измените `engine` и приведите время выполнения и запрос на изменения из профайлера в ответе</em>**
``` sql
mysql> ALTER TABLE orders ENGINE=MyISAM;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> ALTER TABLE orders ENGINE=InnoDB;
Query OK, 5 rows affected (0.02 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> SHOW PROFILES;
+----------+------------+----------------------------------+
| Query_ID | Duration   | Query                            |
+----------+------------+----------------------------------+
|       13 | 0.01985225 | ALTER TABLE orders ENGINE=MyISAM |
|       14 | 0.02428775 | ALTER TABLE orders ENGINE=InnoDB |
+----------+------------+----------------------------------+
2 rows in set, 1 warning (0.00 sec)
```

## Задача 4 

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):

- скорость IO важнее сохранности данных;
- нужна компрессия таблиц для экономии места на диске;
- размер буффера с незакомиченными транзакциями 1 Мб;
- буффер кеширования 30% от ОЗУ;
- размер файла логов операций 100 Мб.

Приведите в ответе изменённый файл `my.cnf`.

``` ini
[mysqld]
innodb_flush_log_at_trx_commit=2
innodb_file_per_table=ON
innodb_log_buffer_size=1M
innodb_buffer_pool_size=1G
innodb_log_file_size=100M

skip-host-cache
skip-name-resolve
datadir=/var/lib/mysql
socket=/var/run/mysqld/mysqld.sock
secure-file-priv=/var/lib/mysql-files
user=mysql
pid-file=/var/run/mysqld/mysqld.pid

[client]
socket=/var/run/mysqld/mysqld.sock
!includedir /etc/mysql/conf.d/
```

---