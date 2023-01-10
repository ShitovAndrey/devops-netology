# Домашнее задание к занятию "3.9. Элементы безопасности информационных систем"
1. Для установки плагина выполнено действие `https://bitwarden.com -> Web Browser -> Google Chrome -> Установить`.
В хранилище добавлены учетные записи для `redhat.com` и `netology.ru`. (Скриншот прилагается).
2. Для включения двухфакторной аутентификации для Bitwarden:
   - Установлено приложение `Google Authenticator` на смартфон;
   - Отсканирован QR код в настройках `https://vault.bitwarden.com -> Настройка аккаунта -> Безопасность ->
     Двухфакторная аутентификация -> Провайдеры -> "Приложение-аутентификатор" -> Управление` (Скриншот прилагается).
3. Выпуск сертификата:
   ``` bash
   root@ubu18:~# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
   > -keyout /etc/ssl/private/apache-selfsigned.key \
   > -out /etc/ssl/certs/apache-selfsigned.crt \
   > -subj "/C=RU/ST=Moscow/L=Moscow/O=Home/OU=Learn/CN=home.learn"
   Generating a RSA private key
   ...................+++++
   ..........................+++++
   writing new private key to '/etc/ssl/private/apache-selfsigned.key'
   ```
   Файл конфигурации виртуального хоста:
   ```
   root@ubu18:~# cat /etc/apache2/sites-available/home.learn.conf
   <VirtualHost *:443>
    ServerName home.learn
    DocumentRoot /var/www/home.learn
    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
   </VirtualHost>
   ```
   Файл index.html
   ``` html
   root@ubu18:~# cat /var/www/home.learn/index.html
   <h1>Hello Netology</h1>
   ```
   Прилагается скриншот доступности ресурса.
   
4. Проверка сaйта `https://nmap.org/` на TLS уязвимости:
   ``` bash
   root@ubu18:~/testssl.sh# ./testssl.sh -U --sneaky https://nmap.org/
   
   ###########################################################
       testssl.sh       3.2rc2 from https://testssl.sh/dev/
       (7670275 2022-12-27 22:06:12)
   
         This program is free software. Distribution and
                modification under GPLv2 permitted.
         USAGE w/o ANY WARRANTY. USE IT AT YOUR OWN RISK!
   
          Please file bugs @ https://testssl.sh/bugs/
   
   ###########################################################
   
    Using "OpenSSL 1.0.2-bad (1.0.2k-dev)" [~183 ciphers]
    on ubu18:./bin/openssl.Linux.x86_64
    (built: "Sep  1 14:03:44 2022", platform: "linux-x86_64")
   
   
    Start 2023-01-08 16:45:30        -->> 45.33.49.119:443 (nmap.org) <<--
   
    Further IP addresses:   2600:3c01:e000:3e6::6d4e:7061
    rDNS (45.33.49.119):    ack.nmap.org.
    Service detected:       HTTP
   
   
    Testing vulnerabilities
   
    Heartbleed (CVE-2014-0160)                not vulnerable (OK), timed out
    CCS (CVE-2014-0224)                       not vulnerable (OK)
    Ticketbleed (CVE-2016-9244), experiment.  not vulnerable (OK)
    ROBOT                                     not vulnerable (OK)
    Secure Renegotiation (RFC 5746)           supported (OK)
    Secure Client-Initiated Renegotiation     not vulnerable (OK)
    CRIME, TLS (CVE-2012-4929)                not vulnerable (OK)
    BREACH (CVE-2013-3587)                    no gzip/deflate/compress/br HTTP compression (OK)  - only supplied "/" tested
    POODLE, SSL (CVE-2014-3566)               not vulnerable (OK)
    TLS_FALLBACK_SCSV (RFC 7507)              Downgrade attack prevention supported (OK)
    SWEET32 (CVE-2016-2183, CVE-2016-6329)    not vulnerable (OK)
    FREAK (CVE-2015-0204)                     not vulnerable (OK)
    DROWN (CVE-2016-0800, CVE-2016-0703)      not vulnerable on this host and port (OK)
                                              make sure you don't use this certificate elsewhere with SSLv2 enabled services, see
                                              https://search.censys.io/search?resource=hosts&virtual_hosts=INCLUDE&q=1BC58A3CDD3ADE2360F1AE44B07FA704E7E5A852B174852F572F0C902D12AE28
    LOGJAM (CVE-2015-4000), experimental      common prime with 2048 bits detected: RFC3526/Oakley Group 14 (2048 bits),
                                              but no DH EXPORT ciphers
    BEAST (CVE-2011-3389)                     TLS1: ECDHE-RSA-AES128-SHA DHE-RSA-AES128-SHA AES128-SHA ECDHE-RSA-AES256-SHA DHE-RSA-AES256-SHA AES256-SHA DHE-RSA-CAMELLIA256-SHA CAMELLIA256-SHA DHE-RSA-SEED-SHA DHE-RSA-CAMELLIA128-SHA SEED-SHA CAMELLIA128-SHA
                                              VULNERABLE -- but also supports higher protocols  TLSv1.1 TLSv1.2 (likely mitigated)
    LUCKY13 (CVE-2013-0169), experimental     potentially VULNERABLE, uses cipher block chaining (CBC) ciphers with TLS. Check patches
    Winshock (CVE-2014-6321), experimental    not vulnerable (OK) - CAMELLIA or ECDHE_RSA GCM ciphers found
    RC4 (CVE-2013-2566, CVE-2015-2808)        no RC4 ciphers detected (OK)
   
   
    Done 2023-01-08 16:47:19 [ 109s] -->> 45.33.49.119:443 (nmap.org) <<--
   ```
5. Установка ssh сервера, генерация новой пары rsa ключей и копирование их на другой хост:\
   Установка ssh сервера
   ```
   andy@ubu18:~$ sudo apt -y install openssh-server
   Reading package lists... Done
   Building dependency tree
   Reading state information... Done
   openssh-server is already the newest version (1:8.2p1-4ubuntu0.5).
   
   andy@ubu18:~$ sudo systemctl enable --now ssh
   Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
   Executing: /lib/systemd/systemd-sysv-install enable ssh
   Created symlink /etc/systemd/system/sshd.service → /lib/systemd/system/ssh.service.
   Created symlink /etc/systemd/system/multi-user.target.wants/ssh.service → /lib/systemd/system/ssh.service.
   ```
   Генерация новой пары rsa ключей
   ```
   andy@ubu18:~$ ssh-keygen -b 2048 -C andy -t rsa
   Generating public/private rsa key pair.
   Enter file in which to save the key (/home/andy/.ssh/id_rsa):
   Enter passphrase (empty for no passphrase):
   Enter same passphrase again:
   Your identification has been saved in /home/andy/.ssh/id_rsa
   Your public key has been saved in /home/andy/.ssh/id_rsa.pub
   The key fingerprint is:
   SHA256:EvbssC/+KwG4GycfJz/JCm09RU4rQoPd9mtbHpJc+fE andy
   The key's randomart image is:
   +---[RSA 2048]----+
   |                 |
   |   o .           |
   |  ..+ = o        |
   |  ...+ O . .     |
   |   ...+ S o .    |
   |  +.+ooO + . o   |
   |  .*o*+oB o . E  |
   |  .o. B+ = .     |
   |    .o.==..      |
   +----[SHA256]-----+
   ```
   Копирование ключа на другой хост
   ```
   andy@ubu18:~$ ssh-copy-id andy@192.168.1.18
   /usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/andy/.ssh/id_rsa.pub"
   /usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
   /usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
   andy@192.168.1.18's password:
   
   Number of key(s) added: 1
   
   Now try logging into the machine, with:   "ssh 'andy@192.168.1.18'"
   and check to make sure that only the key(s) you wanted were added.
   ```
   Подключение на удалённый хост по ключу
   ```
   andy@ubu18:~$ ssh -o PubkeyAuthentication=yes -i ~/.ssh/id_rsa andy@192.168.1.18
   Last login: Thu Dec  1 21:03:18 2022 from 192.168.1.14
   [andy@ubu20 ~]$
   ```

6. Переименование ключей и вход на удалённый сервер по имени\
   Переименование ключей:
   ```
   andy@ubu18:~$ mv .ssh/id_rsa .ssh/id_server2
   andy@ubu18:~$ mv .ssh/id_rsa.pub .ssh/id_server2.pub
   andy@ubu18:~$ ls -al .ssh/
   total 20
   drwx------  2 andy andy 4096 янв 10 21:08 .
   drwxr-xr-x 23 andy andy 4096 янв 10 08:31 ..
   -rw-------  1 andy andy 1811 янв 10 06:15 id_server2
   -rw-r--r--  1 andy andy  386 янв 10 06:15 id_server2.pub
   -rw-r--r--  1 andy andy  444 янв 10 08:27 known_hosts
   ```
   Вход на удалённый сервер по имени:
   ```
   andy@ubu18:~$ cat .ssh/config
   Host ubu20
    HostName 192.168.1.18
    IdentityFile ~/.ssh/id_server2
    User andy
   
   andy@ubu18:~$ ssh ubu20
   Last login: Fri Dec  2 10:45:06 2022 from 192.168.1.14
   [andy@ubu20 ~]$
   ```

7. Дамп 100 пакетов в pcap файл и открытие в wireshark (Скриншот прилагается)
   ```
   andy@ubu18:~$ sudo tcpdump -i enp0s3 -c 100 -w tcpdump_100.pcap
   tcpdump: listening on enp0s3, link-type EN10MB (Ethernet), capture size 262144 bytes
   100 packets captured
   107 packets received by filter
   0 packets dropped by kernel
   ```
