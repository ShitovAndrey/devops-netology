# Домашнее задание к занятию "3.4. Операционные системы. Лекция 2" 
1. Юнит для node_exporter

    **Содержимое unit файла. Вывод команды `systemctl cat node_exporter`.**
    ```
    # /etc/systemd/system/node_exporter.service
    [Unit]
    Description="node_exporter"

    [Service]
    EnvironmentFile=-/etc/default/node_exporter
    ExecStart=/usr/sbin/node_exporter $NODE_OPTS

    [Install]
    WantedBy=multi-user.target
    ```
    **Содержимое файла опций. Переопределён tcp порт с 9100 на 9101 Вывод команды `cat /etc/default/node_exporter`.**
   ```
   NODE_OPTS='--web.listen-address=":9101"'
   ```
   **Вывод команды `systemctl status node_exporter`**
   ```
   ● node_exporter.service - "node_exporter"
        Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
        Active: active (running) since Tue 2022-11-01 17:24:46 MSK; 7min ago
      Main PID: 7184 (node_exporter)
         Tasks: 5 (limit: 2305)
        Memory: 5.5M
        CGroup: /system.slice/node_exporter.service
                └─7184 /usr/sbin/node_exporter --web.listen-address=:9101
   ```

2. Опции node_exporter для базового мониторинга:
    * `--collector.os, --collector.dmi` - Сбор инвентарных данных.
    * `--collector.loadavg` - Мониторинг загрузки системы.
    * `--collector.cpu, --collector.cpufreq` - Мониторинг утилизации ресурсов CPU.
    * `--collector.meminfo` - Мониторинг использования памяти.
    * `--collector.filesystem` - Мониторинг использования файловых систем.
    * `--collector.diskstats` - Мониторинг дисков.
    * `--collector.netclass, --collector.netdev, --collector.netstat` - Мониторинг сетевых интерфейсов.
3. После изменения параметра `bind` на `0.0.0.0` web интерфейс стал доступен. Скриншот task3_netdata по дополнительной
ссылке.
4. Да, можно. В выводе `dmesg` появляется указывающая на это запись `Hypervisor detected: KVM`.  
5. Параметр `fs.nr_open` имеет значение по умолчанию `1048576`. Данный параметр задает максимальное кол-во файловых
дескрипторов для одного процесса на уровне системы. Фактический лимит зависит от лимита ресурсов `RLIMIT_NOFILE` который
можно посмотреть и изменить командой `ulimit -n` или через файл `/etc/security/limits.conf`, так же можно создать
конфигурацию в директории `/etc/security/limits.d/`.
6. Скриншоты task6_nsenter01 и task6_nsenter02 по дополнительной ссылке.
7. Конструкция `:(){ :|:& };:` называется **форк-бомбой** и является описанием функции с именем `:` в теле которой
происходит рекурсивной вызов двух экземпляров данной функции в фоне. Из-за отсутствия ограничивающих запуск новых 
экземпляров условий, функция в прогрессии порождает новые процессы. Стабилизировать помог механизм cgroup который
ограничил кол-во процессов для конкретного пользователя. По умолчанию для systemd user-$UID.sllice выставляется значение
равное 33% от параметра `sysctl kernel.threads-max`. Можно увеличить через изменение параметра `kernel.threads-max` или
для конкретного пользователя командой `systemctl set-property user-1000.slice TasksMax=<НУЖНОЕ_ЧИСЛО>`, или в файле
конфигурации `/etc/systemd/system.conf` параметр `DefaultTasksMax` для всех slice.

---

# Домашнее задание к занятию "3.3. Операционные системы. Лекция 1"
1. Команда `cd` делает системный вызов `chdir`, в выводе `strace` отображается как `chdir("/tmp")`.
2. Команда `file` обращается к базе по пути `/usr/share/misc/magic.mgc`, так же поиск шаблона осуществлялся в файлах
`/etc/magic.mgc` и `/etc/magic`.
3. Вариант обнуления открытого удалённого файла:
    * Определяем PID процесса пишущего в файл `lsof -nP | grep '(deleted)'`
    * Определяем номер FD файла `ls -al /proc/<PID>/fd`
    * Используя FD обнуляем файл `truncate --size=0M /proc/<PID>/fd/<FD_NUMBER>` 
4. Процессы `zombie` не занимают ресурсы ОС.
5. Вывод команды `opensnoop-bpfcc` за первую секунду: 
    ```
    PID    COMM               FD ERR PATH
    294    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.procs
    294    systemd-udevd      14   0 /sys/fs/cgroup/unified/system.slice/systemd-udevd.service/cgroup.threads
    1055   vminfo              6   0 /var/run/utmp
    ```
6. Команда `uname -a` использует системный вызов `uname`. Цитата из man:
    > Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version,
      domainname}.
7. Отличие оператора `;` от `&&` заключается в том, что в первом случаи будут безусловно выполнены все команды в
последовательности, а во втором случаи каждая следующая команда в последовательности будет запущена, только если код
возврата предыдущей команды равен `0` (успешное завершение).
    > The shell does not exit if the command that fails is . . . part of any command executed in a && or || list except
the command following the final &&  
8. Опции `set`:
    * `-e` - завершает процесс bash если какая-либо команда вернёт не нулевой код завершения.
    * `-u` - обращение к не инициализированной переменной будет вызывать ошибку.
    * `-x` - выводит команды и их аргументы по мере выполнения команд.
    * `-o pipefail` - при установлении этой опции, в случаи возникновения ошибке в одной из команд конвейера, будет
возвращается не нулевой код возврата, даже если последняя команда завершилось успешно с кодом 0.

Использование `-e` позволяет избежать проблемы, когда сценарий завершается успешно потому что успешно завершилась
последняя в нём команда, хотя были ошибки выполнения других команд скрипта. Так же позволяет прервать выполнения
сценария и не допустить непредсказуемого результата работы скрипта при возникающих ошибках в командах. Опция `-u`
позволяет выявлять опечатки в именах переменных за счет этого упростить процесс отладки. Опция `-x` позволяет 
упростить процесс отладки за счет визуального отображая последовательности выполняемых команд и их аргументов,
последние будут раскрыты в значения если для их установки используются переменные. Опция `-o pipefail` позволит
контролировать возникающие ошибки в конвейерах за счёт этого ориентироваться на корректный код возврата, а не на код 
завершения последней команды в нём.

9. Наиболее частым статусом процесса является `S - sleeping (TASK_INTERRUPTIBLE)`. Дополнительные статусы:
    * `<`    high-priority (not nice to other users)
    * `N`    low-priority (nice to other users)
    * `L`    has pages locked into memory (for real-time and custom IO)
    * `s`    is a session leader
    * `l`    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
    * `+`    is in the foreground process group


---
# Домашнее задание к занятию "3.2. Работа в терминале, лекция 2"
1. Команда `cd` относиться к типу **встроенных команд** в оболочку, об этом нам сообщает вывод команды `type cd`.
По причине что **внешние команды** выполняются в отдельном процессе который порождает оболочка, функцию по изменению
рабочего каталога `cd` не получиться реализовать этого типа, т.к. у каждой сессии свой рабочий каталог и при вызове
не определить у какой сеcсии менять директорию.
***Наверняка технически сделать `cd` в виде внешней команды можно, но сложность такой реализации будет не оправдана.***
2. Альтернатива или корректный вариант команды `grep <some_string> <some_file> | wc -l` без PIPE, будет использование
опции `-c --count` в `grep`. Пример: `grep -c root /etc/passwd` выведет кол-во строк содержащих **root**
в файле **/etc/passwd**. 
3. Вывод команды `pstree -p` показывает что родителям всех процессов является процесс **systemd** который имеет PID `1`.
4. Перенаправление `stderr` команды `ls` выглядит как `ls -R /proc/ 2>/dev/pts/1`. Для появления ошибок `ls` вызывается
рекурсивно для `/proc`. Номер `pts` зависит от сессии в которую хотим выполнить перенаправление. Ещё вариант
`ls -R /proc/ 2>/proc/1591/fd/1`, где 1591 `PID` командной оболочки сессии другого терминала.
5. Получится. `grep root < /etc/passwd > /tmp/grep_passwd`.
6. Находясь в графическом режиме наблюдать данные отправленные на TTY не сможем. Если отправить данные на `/dev/tty3`
и переключиться используя клавиши `Ctrl + Alt + F3`, то отправленные данные можно увидить.
7. Запускается новый процесс `bash`, создается файловый дескриптор `5` и перенаправляется на `stdin` FD `1`.
Результатам команды `echo netology > /proc/$$/fd/5` будет надпись `netology` в консоли, так происходит потому что
на первом шаге мы связали stdout FD `5` с stdin FD `1` и всё что попадает на stdin FD `5` будет перенаправлено в FD `1`,
соответственно выведено на консоль.
8. Получиться если поменять потоки местами, пример команды `ls -R /proc/ 3>&1 1>&2 2>&3 | grep . > qwer.err` в файл
qwer.err попадет только поток ошибок переданный на вход утилиты `grep` через pipe.
9. Команда выводит начальное переменное окружение процесса. Командой `env` можно посмотреть текущие переменное
окружение сеанса.
10. По пути `/proc/$$/cmdline` доступна командная строка которая запустила текущей сеанс. По пути `/proc/$$/exe` доступен
исполняемый файл `bash`, собственно `/proc/$$/exe` является символьной ссылкой на него.
11. `sse4_2`
12. По умолчанию для выполнения команды через `ssh` tty не назначается. Из man ***Если псевдо-tty не выделен,
сеанс прозрачен и может использоваться для надежной передачи двоичных данных***.  Ключ `-t` команды `ssh`
принудительно назначит терминал.
14. Команда `tee` позволяет полученные на stdin данные одновременно вывести на stdout консоли и записать их в файл.
Конструкция `echo string | sudo tee /root/new_file` работает потому что выводом на stdout и записью в файл занимается
процесс `tee` который может повысить привилегии используя sudo, в отличии от процесса оболочки.


---


# Домашнее задание к занятию "3.1. Работа в терминале, лекция 1"
5. Ресурсы выделяемые vagrant по-умолчанию. 
  - ОЗУ - 1024МБ
  - CPU - 2
  - DISK - 64ГБ (box bento/ubuntu-20.04)

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
