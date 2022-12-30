# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

### Цель задания

В результате выполнения этого задания вы:

1. Познакомитесь с синтаксисами JSON и YAML.
2. Узнаете как преобразовать один формат в другой при помощи пары строк.

### Чеклист готовности к домашнему заданию

Установлена библиотека pyyaml для Python 3.

### Инструкция к заданию 

1. Скопируйте в свой .md-файл содержимое этого файла; исходники можно посмотреть [здесь](https://raw.githubusercontent.com/netology-code/sysadm-homeworks/devsys-24/04-script-03-yaml/README.md).
2. Заполните недостающие части документа решением задач (заменяйте `???`, остальное в шаблоне не меняйте, чтобы не сломать форматирование текста, подсветку синтаксиса и прочее) и отправляйте на проверку. Вместо логов можно вставить скриншоты по желанию.
3. Любые вопросы по выполнению заданий спрашивайте в чате учебной группы и/или в разделе “Вопросы по заданию” в личном кабинете.


------

## Задание 1

## Обязательная задача 1
Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш скрипт:
```
{
	"info": "Sample JSON output from our service\\t",
	"elements": [{
		"name": "first",
		"type": "server",
		"ip": 7175
	}, {
		"name": "second",
		"type": "proxy",
		"ip": "71.78.22.43"
	}]
}
```

---

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
import socket
import json
import yaml

WEB_SERVICE_LIST = ("yandex.ru", "mail.ru", "nic.ru")
DUMP_FILE_PATH   = "dump_service.raw"
JSON_DUMP_PATH   = "dump.json"
YAML_DUMP_PATH   = "dump.yaml"

service_ip_list   = dict()
dump_service_list = dict()

dump_json = dict()
dump_yaml = list()


# Init service dict
for service_item in WEB_SERVICE_LIST:
    service_ip = socket.gethostbyname(service_item)
    service_ip_list.update({service_item: {"ip": service_ip}})
    dump_json.update({service_item: service_ip})
    dump_yaml.append({service_item: service_ip})

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

# Write yaml to file
with open(JSON_DUMP_PATH, "w") as dump_file:
    dump_file.write(json.dumps(dump_json))

# Write json to file
with open(YAML_DUMP_PATH, "w") as dump_file:
    dump_file.writelines("---\n")
    dump_file.write(yaml.dump(dump_yaml))
    dump_file.writelines("...\n")

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
[andrey@v2-nx-app010 yaml]$ ./02.py 
yandex.ru - 77.88.55.55
mail.ru - 94.100.180.201
nic.ru - 31.177.80.4
[ERROR] yandex.ru IP mismatch: 5.255.255.88 77.88.55.55
[ERROR] mail.ru IP mismatch: 217.69.139.200 94.100.180.201
[ERROR] nic.ru IP mismatch: 31.177.76.4 31.177.80.4
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
{"yandex.ru": "77.88.55.55", "mail.ru": "94.100.180.201", "nic.ru": "31.177.80.4"}
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
- yandex.ru: 77.88.55.55
- mail.ru: 94.100.180.201
- nic.ru: 31.177.80.4
...

```

---
