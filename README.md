# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"
5. Ресурсы выделяемые vagrant по-умолчанию. 
  - ОЗУ - 1024МБ
  - CPU - 2
  - DISK - 64ГБ

6. Для добавления ОЗУ или увеличения кол-во CPU:
  - Остановить ВМ командой vagrant halt.
  - В блок Vagrant.configure файла Vagrantfile добавить блок config.vm.provider "virtualbox".
Параметр *.memory задает объем оперативной памяти,
параметр *.cpus задает кол-во cpu
```
  config.vm.provider "virtualbox" do |v|
    v.memory = 2024
    v.cpus = 3
  end
```

8. Bash history
- Переменная HISTSIZE задаёт длину (кол-во хранящихся строк в истории) журнала history. Описание в man bash начинается со строки 590.
- Директива ignoreboth не допускает попадание в журнал истории команд начинающихся с пробела или одинаковых подряд команд.

9. Скобки {} применимы в сценариях работы со множеством объектов где должны быть сгенерированы определённые строки (частный случай создания множество файлов с генерацией имён). Описание в man bash начинается со строки 740.
10. Однократный вызов команды touch file{1..100000} создаст 100000 файлов. Аналогичным способом создать 300000 файлов не получиться, потому что у bash задано соответствующие ограничение на кол-во аргументов. А т.к. раскрытие скобок {} фактически генерируют огромную строку для bash, то команда упирается в ограничения.
11. Конструкция [[ -d /tmp ]] проверяет условие "Существует ли файл и является ли каталогом."
12. Результат достигнут после выполнения последовательности команд:
  - PATH=/tmp/new_path_directory:${PATH}
  - mkdir /tmp/new_path_directory
  - ln -s /usr/bin/bash /tmp/new_path_directory/bash или cp -a /usr/bin/bash /tmp/new_path_directory/
13. batch в отличии от at можно использовать только в интерактивном режиме, команду at можно использовать как в интерактивном, так и в командном режиме. at ориентируется на время когда выполнять сценарий, batch ориентируется на среднею загрузку системы (load average).


# Домашнее задание к занятию «2.4. Инструменты Git»
1. aefead2207ef7e2aa5dc81a34aedf0cad4c32545, Update CHANGELOG.md. Результат команды: git show aefea
2. tag: v0.12.23. Результат команды: git show 85024d3
3. Два родителя 56cd7859e05c36c06b56d013b55a252d0bb7e158 и 9ea88f22fc6269854151c571162c5bcf958bee2b. Результат команды: git show --format=%P b8d720
4. Результат команды: git log --format=%H%n%s%n v0.12.24...v0.12.23 --boundary

|                    Hash                    | Subject                                                           |
|:------------------------------------------:|:------------------------------------------------------------------|
|  33ff1c03bb960b332be3af2e333462dde88b279e  | v0.12.24                                                          |
|  b14b74c4939dcab573326f4e3ee2a62e23e12f89  | [Website] vmc provider links                                      |
|  3f235065b9347a758efadc92295b540ee0a5e26e  | Update CHANGELOG.md                                               |
|  6ae64e247b332925b872447e9ce869657281c2bf  | registry: Fix panic when server is unreachable                    |
|  5c619ca1baf2e21a155fcdb4c264cc9e24a2a353  | website: Remove links to the getting started guide's old location |
|  06275647e2b53d97d4f0a19a0fec11f6d69820b5  | Update CHANGELOG.md                                               |
|  d5f9411f5108260320064349b757f55c09bc4b80  | command: Fix bug when using terraform login on Windows            |
|  4b6d06cc5dcb78af637bbb19c198faff37a066ed  | Update CHANGELOG.md                                               |
|  dd01a35078f040ca984cdd349f18d0b67e486c35  | Update CHANGELOG.md                                               |
|  225466bc3e5f35baa5d07197bbc079345b77525e  | Cleanup after v0.12.23 release                                    |
|  85024d3100126de36331c6982bfaac02cdab9e76  | v0.12.23                                                          |

5. commit 8c928e83589d90a031f811fae52a81be7153e82f. Визуально определил создание функции. Результат команды: git log -S'func providerSource' --oneline; git show 8c928e8358
6. Результат команды: git grep -p globalPluginDirs; git log -L :globalPluginDirs:plugins.go --format=%H%n%s%n

|                    Hash                    | Subject                                               |
|:------------------------------------------:|:------------------------------------------------------|
|  78b12205587fe839f10d946ea3fdc06719decb05  | Remove config.go and update things using its aliases  |
|  52dbf94834cb970b510f2fba853a5b49ad9b1a46  | keep .terraform.d/plugins for discovery               |
|  41ab0aef7a0fe030e84018973a64135b11abcd70  | Add missing OS_ARCH dir to global plugin paths        |
|  66ebff90cdfaa6938f26f908c7ebad8d547fea17  | move some more plugin search path logic to command    |
|  8364383c359a6b738a436d1b7745ccdce178df47  | Push plugin discovery down into command package       |

7. commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5, Author: Martin Atkins <mart@degeneration.co.uk> Визуально определил создание функции. Результат команды: git log -S"func synchronizedWriters" --oneline; git show 5ac311e2a9



---
# devops-netology
- This line is first added.
- This line is second added.

#Terraform ignore
- Будут игнорироваться все файлы во всех (в т.ч. вложенных) каталогах .terraform
- Будут проигнорированы файлы заканчивающиеся на .tfstate расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы содержащие в своем названии .tfstate. расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы crash.log расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы начинающиеся на crash. и заканчивающиеся на .log расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы заканчивающиеся на .tfvars и tfvars.json расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы override.tf и override.tf.json расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы заканчивающиеся на _override.tf и _override.tf.json расположенные на одном уровне с .gitignore файлом.
- Будут проигнорированы файлы .terraformrc и terraform.rc расположенные на одном уровне с .gitignore файлом.
