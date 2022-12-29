# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с синтаксисом Python.
2. Узнаете, для каких типов задач его можно использовать.
3. Воспользуетесь несколькими модулями для работы с ОС.


### Инструкция к заданию

1. Установите Python 3 любой версии.
2. Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys10/04-script-01-bash/README.md).
3. Заполните недостающие части документа решением задач (заменяйте `???`, остальное в шаблоне не меняйте, чтобы не сломать форматирование текста, подсветку синтаксиса). Вместо логов можно вставить скриншоты по желанию.
4. Для проверки домашнего задания преподавателем в личном кабинете прикрепите и отправьте ссылку на решение в виде md-файла в вашем Github.
5. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.

------

## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ |
| ------------- | ------------- |
| Какое значение будет присвоено переменной `c`?  | Значение присвоено не будет. Так как переменная `a` типа `int`, а переменная `b` типа `str` попытка присвоения завершится ошибкой `TypeError: unsupported operand type(s) for +: 'int' and 'str'`.  |
| Как получить для переменной `c` значение 12?  | Привести значение переменной `a` к типу `str` через конструкцию `a = str(a)` перед операцией конкатенации или изначально присвоить строковое значение для переменной `a = '1'`  |
| Как получить для переменной `c` значение 3?  | Привести значение переменной `b` к типу `int` через конструкцию `b = int(b)` перед операцией сложения или изначально присвоить целочисленное значение для переменной `b = 2`  |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

GIT_REPO_PATH="~/python/netlog/python/git/tools"

bash_command = ["cd " + GIT_REPO_PATH, "git status"]
pwd_cmd      = ["cd " + GIT_REPO_PATH, "pwd"]

result_os     = os.popen(' && '.join(bash_command)).read()
pwd_result_os = os.popen(' && '.join(pwd_cmd)).read()
is_change = False

for result in result_os.split('\n'):
    if (result.find('modified') != -1 or result.find('new file') != -1):
        prepare_result = result.replace('\tmodified:   ', '')
        prepare_result = prepare_result.replace('\tnew file:   ', '')
        print(pwd_result_os.split('\n')[0] + "/" + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
[andrey@v2-nx-app010 python]$ ./02.py 
/home/andrey/python/netlog/python/git/tools/README.md
/home/andrey/python/netlog/python/git/tools/ping_host/ping_host.txt
/home/andrey/python/netlog/python/git/tools/.gitlab-ci.yml
```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import sys

GIT_REPO_PATH="~/python/netlog/python/git/tools"


if (len(sys.argv) > 1):
    if os.path.isdir(sys.argv[1]):
        GIT_REPO_PATH=sys.argv[1]
    else:
        print("The repo path (" + sys.argv[1] + ") is not exist", file=sys.stderr)
        exit(128)

bash_command = ["cd " + GIT_REPO_PATH, "git status"]
pwd_cmd      = ["cd " + GIT_REPO_PATH, "pwd"]

result_os     = os.popen(' && '.join(bash_command)).read()
pwd_result_os = os.popen(' && '.join(pwd_cmd)).read()
is_change = False

for result in result_os.split('\n'):
    if (result.find('modified') != -1 or result.find('new file') != -1):
        prepare_result = result.replace('\tmodified:   ', '')
        prepare_result = prepare_result.replace('\tnew file:   ', '')
        print(pwd_result_os.split('\n')[0] + "/" + prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
[andrey@v2-nx-app010 python]$ ./03.py
/home/andrey/python/netlog/python/git/tools/README.md
/home/andrey/python/netlog/python/git/tools/ping_host/ping_host.txt
/home/andrey/python/netlog/python/git/tools/.gitlab-ci.yml

[andrey@v2-nx-app010 python]$ ./03.py "/home/andrey/python/netlog/python/git/testing"
/home/andrey/python/netlog/python/git/testing/README.md
/home/andrey/python/netlog/python/git/testing/default/check_list.yaml

[andrey@v2-nx-app010 python]$ ./03.py "/home/andrey/python/netlog/python/git/no_path"
The repo path (/home/andrey/python/netlog/python/git/no_path) is not exist
```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import socket
import json

WEB_SERVICE_LIST = ("yandex.ru", "mail.ru", "nic.ru")
DUMP_FILE_PATH   = "dump_service.raw"

service_ip_list   = dict()
dump_service_list = dict()


# Init service dict
for service_item in WEB_SERVICE_LIST:
    service_ip = socket.gethostbyname(service_item)
    service_ip_list.update({service_item: {"ip": service_ip}})

# Print Service
for service_item in WEB_SERVICE_LIST:
    print('{service} - {ip}'.format(service=service_item, ip=service_ip_list.get(service_item)["ip"]))

# Read dump from file 
if os.path.isfile(DUMP_FILE_PATH):
    data = ""
    with open(DUMP_FILE_PATH, "r") as dump_file:
        data = dump_file.read()
    dump_service_list = json.loads(data)

# Write dump to file 
with open(DUMP_FILE_PATH, "w") as dump_file:
    dump_file.write(json.dumps(service_ip_list))

# Check ip
if dump_service_list:
    for service_item in WEB_SERVICE_LIST:
        ip_current = service_ip_list.get(service_item)["ip"]
        ip_old     = dump_service_list.get(service_item)["ip"]
        if ip_current != ip_old:
            print("[ERROR] {service} IP mismatch: {ip_old} {ip_current}".format(service=service_item,
                                                                                ip_current=ip_current, ip_old=ip_old))
```

### Вывод скрипта при запуске при тестировании:
```
[andrey@v2-nx-app010 python]$ ./04.py 
yandex.ru - 77.88.55.88
mail.ru - 217.69.139.200
nic.ru - 31.177.80.4

[andrey@v2-nx-app010 python]$ ./04.py 
yandex.ru - 77.88.55.88
mail.ru - 94.100.180.200
nic.ru - 31.177.80.4
[ERROR] mail.ru IP mismatch: 217.69.139.200 94.100.180.200

[andrey@v2-nx-app010 python]$ ./04.py 
yandex.ru - 5.255.255.70
mail.ru - 94.100.180.200
nic.ru - 31.177.76.4
[ERROR] yandex.ru IP mismatch: 77.88.55.88 5.255.255.70
[ERROR] nic.ru IP mismatch: 31.177.80.4 31.177.76.4
```

------
