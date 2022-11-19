# Домашнее задание к занятию "3.7. Компьютерные сети. Лекция 2"
1. Примеры команд вывода информации по сетевым интерфейсам:
   * Для Linux:
   ```
   root@ubu18:~# ip -br address
   lo               UNKNOWN        127.0.0.1/8 ::1/128
   enp0s3           UP             192.168.1.11/24 fe80::6d12:4343:68d0:b754/64
   
   root@ubu18:~# ifconfig -s
   Iface      MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
   enp0s3    1500   245634      0   2372 0        120376      0      0      0 BMRU
   lo       65536     2263      0      0 0          2263      0      0      0 LRU
   
   root@ubu18:~# nmcli dev status
   DEVICE  TYPE      STATE      CONNECTION
   enp0s3  ethernet  connected  Wired connection 1
   lo      loopback  unmanaged  --
   ```
   * Для Windows:
   ```
   PS C:\Users\Andy> ipconfig /all
      Адаптер Ethernet Ethernet 5:
   
      Описание. . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter
      Физический адрес. . . . . . . . . : 0A-00-27-00-00-05
      DHCP включен. . . . . . . . . . . : Нет
      Автонастройка включена. . . . . . : Да
      IPv4-адрес. . . . . . . . . . . . : 192.168.56.1(Основной)
      Маска подсети . . . . . . . . . . : 255.255.255.0
      DNS-серверы. . . . . . . . . . . : fec0:0:0:ffff::1%1
                                          fec0:0:0:ffff::2%1
                                          fec0:0:0:ffff::3%1
      NetBios через TCP/IP. . . . . . . . : Включен
   
   PS C:\Users\Andy> Get-NetIPAddress | Format-Table
   ifIndex IPAddress                                       PrefixLength PrefixOrigin SuffixOrigin AddressState PolicyStore
   ------- ---------                                       ------------ ------------ ------------ ------------ -----------
   5       192.168.56.1                                              24 Manual       Manual       Preferred    ActiveStore
   1       127.0.0.1                                                  8 WellKnown    WellKnown    Preferred    ActiveStore
   
   PS C:\Users\Andy> Get-NetAdapter
   Name                      InterfaceDescription                    ifIndex Status       MacAddress             LinkSpeed
   ----                      --------------------                    ------- ------       ----------             ---------
   Ethernet 5                VirtualBox Host-Only Ethernet Adapter         5 Up           0A-00-27-00-00-05         1 Gbps
   
   PS C:\Users\Andy> Get-NetIPInterface
   ifIndex InterfaceAlias                  AddressFamily NlMtu(Bytes) InterfaceMetric Dhcp     ConnectionState PolicyStore
   ------- --------------                  ------------- ------------ --------------- ----     --------------- -----------
   5       Ethernet 5                      IPv6                  1500              25 Enabled  Connected       ActiveStore
   
   ```
2. Для распознавания соседей по сетевому интерфейсу используются протоколы CDP (Проприетарный Cisco) и LLDP. В Linux
есть пакет `lldpd` который устанавливает `LLDP daemon` сервис в операционную систему и команды `lldpctl`, `lldpcli`.\
Пример вывода соседей:
   ```
   root@ubu18:~# lldpcli show neighbors
   -------------------------------------------------------------------------------
   LLDP neighbors:
   -------------------------------------------------------------------------------
   Interface:    enp0s3, via: LLDP, RID: 3, Time: 0 day, 00:09:05
     Chassis:
       ChassisID:    mac 08:00:27:35:77:41
       SysName:      mdl01.redlinx.ru
       SysDescr:     CentOS Linux 8 Linux 4.18.0-305.3.1.el8.x86_64 #1 SMP Tue Jun 1 16:14:33 UTC 2021 x86_64
       MgmtIP:       192.168.1.14
       MgmtIP:       fe80::a00:27ff:fe35:7741
       Capability:   Bridge, off
       Capability:   Router, off
       Capability:   Wlan, off
       Capability:   Station, on
     Port:
       PortID:       mac 08:00:27:35:77:41
       PortDescr:    enp0s3
       TTL:          120
   -------------------------------------------------------------------------------
   ```
3. Для разделения L2 коммутатора на несколько виртуальных сетей используется технология `VLAN` (стандарт IEEE 802.1Q). 
Эта технология позволяет тегировать кадры, добавляя в них `VLAN ID` на основании которого и выполняется разделение.
Для использования технологии в Ubuntu необходимо установить пакет `vlan` и подгрузить модуль ядра `modprobe 8021q`
(`echo "8021q" >> /etc/modules'`). Добавление интерфейса с VLAN ID осуществляется командами `vconfig` (deprecated), 
`ip` и так же можно создать используя NetwokrManager командами `nmcli`, `nmtui`.\
Пример конфигурации VLAN (VLAN ID 22 через файл, VLAN ID 33 через nmtui):
   ```
   root@ubu18:~# cat /etc/network/interfaces
   # interfaces(5) file used by ifup(8) and ifdown(8)
   auto lo
   iface lo inet loopback
   
   auto enp0s3.22
   iface enp0s3.22 inet dhcp
     vlan_raw_device enp0s3
     
   root@ubu18:~# ip -c a
   1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
       link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
       inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
       inet6 ::1/128 scope host
          valid_lft forever preferred_lft forever
   2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
       link/ether 08:00:27:20:b2:ef brd ff:ff:ff:ff:ff:ff
       inet 192.168.1.11/24 brd 192.168.1.255 scope global dynamic noprefixroute enp0s3
          valid_lft 86358sec preferred_lft 86358sec
       inet6 fe80::6d12:4343:68d0:b754/64 scope link noprefixroute
          valid_lft forever preferred_lft forever
   3: enp0s3.33@enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
       link/ether 08:00:27:20:b2:ef brd ff:ff:ff:ff:ff:ff
       inet6 fe80::a00:27ff:fe20:b2ef/64 scope link
          valid_lft forever preferred_lft forever
   6: enp0s3.22@enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
       link/ether 08:00:27:20:b2:ef brd ff:ff:ff:ff:ff:ff
       inet6 fe80::a00:27ff:fe20:b2ef/64 scope link
          valid_lft forever preferred_lft forever
   ```
4. Для агрегации сетевых интерфейсов в Linux используются методы `Bonding` (интерфейсы `bondX`) и `Teaming` (интерфейсы 
`teamX`).\
**Для балансировки используются режимы:**

|                  Режим                   | Описание                                                                                                                                                                                 |
|:----------------------------------------:|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|           mode=0 (balance-rr)            | Балансировка `Round-robin`, пакеты последовательно направляются на интерфейсы в LAG.                                                                                                     |
|           mode=2 (balance-xor)           | Пакеты распределяются между интерфейсами по формуле ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов. Один и тот же интерфейс работает с определённым получателем. |
 |             mode=4 (802.3ad)             | Агрегация интерфейсов используя протокол LACP (802.3ad)                                                                                                                                  |
|           mode=5 (balance-tlb)           | Adaptive Transmit Load Balancing - входящие пакеты принимаются только активным сетевым интерфейсом, исходящий распределяется в зависимости от текущей загрузки каждого интерфейса.       |
|           mode=6 (balance-alb)           | Adaptive Load Balancing - входящие и исходящие пакеты распределяются по интерфейсам LAG в зависимости от нагрузки.                                                                       |

**Так же возможные режимы:**

|                  Режим                   | Описание                                                                                                                       |
|:----------------------------------------:|:-------------------------------------------------------------------------------------------------------------------------------|
|          mode=1 (active-backup)          | В передаче пакетов используется один интерфейс из группы, если он теряет линк, то трафик переключается на резервный интерфейс. |
|            mode=3 (broadcast)            | Все пакеты отправляются на все интерфейсы.                                                                                     |

**Пример конфигурации:**
   ```
   root@ubu18:~# cat /etc/network/interfaces
   # interfaces(5) file used by ifup(8) and ifdown(8)
   auto lo
   iface lo inet loopback
   
   auto enp0s8
   iface enp0s8 inet manual
       bond-master bond0
   
   auto enp0s9
   iface enp0s9 inet manual
       bond-master bond0
   
   iface bond0 inet dhcp
     bond_mode balance-tlb
     bond_miimon 100
     bond_downdelay 200
     bond_updelay 200
     slaves enp0s8 enp0s9
   
   
   root@ubu18:~# cat /proc/net/bonding/bond0
   Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)
   
   Bonding Mode: transmit load balancing
   Primary Slave: None
   Currently Active Slave: enp0s8
   MII Status: up
   MII Polling Interval (ms): 100
   Up Delay (ms): 200
   Down Delay (ms): 200
   Peer Notification Delay (ms): 0
   
   Slave Interface: enp0s8
   MII Status: up
   Speed: 1000 Mbps
   Duplex: full
   Link Failure Count: 0
   Permanent HW addr: 08:00:27:cd:76:72
   Slave queue ID: 0
   
   Slave Interface: enp0s9
   MII Status: up
   Speed: 1000 Mbps
   Duplex: full
   Link Failure Count: 0
   Permanent HW addr: 08:00:27:34:b0:15
   Slave queue ID: 0
   ```

5. В сети с маской `/29` 8 IP адресов, из которых 6 IP адресов для хостов (полезные адреса), один широковещательный
адрес (максимальный адрес в диапазоне) и  один адрес под идентификацию самой подсети (минимальный адрес в диапазоне).\
Пример для подсети 192.168.1.8/29:
   ```
   root@ubu18:~# ipcalc -n 192.168.1.8/29
   Address:   192.168.1.8          11000000.10101000.00000001.00001 000
   Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
   Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
   =>
   Network:   192.168.1.8/29       11000000.10101000.00000001.00001 000
   HostMin:   192.168.1.9          11000000.10101000.00000001.00001 001
   HostMax:   192.168.1.14         11000000.10101000.00000001.00001 110
   Broadcast: 192.168.1.15         11000000.10101000.00000001.00001 111
   Hosts/Net: 6                     Class C, Private Internet
   ```
   Из сети с маской `/24` можно получить `32` подсети с маской `/29`.\
   Пример для сети 10.10.10.0.24: 
   ```
   root@ubu18:~# ipcalc 10.10.10.0/24 29
   Address:   10.10.10.0           00001010.00001010.00001010. 00000000
   Netmask:   255.255.255.0 = 24   11111111.11111111.11111111. 00000000
   Wildcard:  0.0.0.255            00000000.00000000.00000000. 11111111
   =>
   Network:   10.10.10.0/24        00001010.00001010.00001010. 00000000
   HostMin:   10.10.10.1           00001010.00001010.00001010. 00000001
   HostMax:   10.10.10.254         00001010.00001010.00001010. 11111110
   Broadcast: 10.10.10.255         00001010.00001010.00001010. 11111111
   Hosts/Net: 254                   Class A, Private Internet
   
   Subnets after transition from /24 to /29
   
   Netmask:   255.255.255.248 = 29 11111111.11111111.11111111.11111 000
   Wildcard:  0.0.0.7              00000000.00000000.00000000.00000 111
   
    1.
   Network:   10.10.10.0/29        00001010.00001010.00001010.00000 000
   HostMin:   10.10.10.1           00001010.00001010.00001010.00000 001
   HostMax:   10.10.10.6           00001010.00001010.00001010.00000 110
   Broadcast: 10.10.10.7           00001010.00001010.00001010.00000 111
   Hosts/Net: 6                     Class A, Private Internet
   
    2.
   Network:   10.10.10.8/29        00001010.00001010.00001010.00001 000
   HostMin:   10.10.10.9           00001010.00001010.00001010.00001 001
   HostMax:   10.10.10.14          00001010.00001010.00001010.00001 110
   Broadcast: 10.10.10.15          00001010.00001010.00001010.00001 111
   Hosts/Net: 6                     Class A, Private Internet
   
   ...
    
    31.
   Network:   10.10.10.240/29      00001010.00001010.00001010.11110 000
   HostMin:   10.10.10.241         00001010.00001010.00001010.11110 001
   HostMax:   10.10.10.246         00001010.00001010.00001010.11110 110
   Broadcast: 10.10.10.247         00001010.00001010.00001010.11110 111
   Hosts/Net: 6                     Class A, Private Internet
   
    32.
   Network:   10.10.10.248/29      00001010.00001010.00001010.11111 000
   HostMin:   10.10.10.249         00001010.00001010.00001010.11111 001
   HostMax:   10.10.10.254         00001010.00001010.00001010.11111 110
   Broadcast: 10.10.10.255         00001010.00001010.00001010.11111 111
   Hosts/Net: 6                     Class A, Private Internet
   
   
   Subnets:   32
   Hosts:     192
   ```

6. Допустимо взять адреса из диапазона `100.64.0.0 — 100.127.255.255`.\
Пример подсети подходящий для 40-50 хостов (`100.64.0.0/26`):
   ```
   root@ubu18:~# ipcalc 100.64.0.0/10 -s 50
   Address:   100.64.0.0           01100100.01 000000.00000000.00000000
   Netmask:   255.192.0.0 = 10     11111111.11 000000.00000000.00000000
   Wildcard:  0.63.255.255         00000000.00 111111.11111111.11111111
   =>
   Network:   100.64.0.0/10        01100100.01 000000.00000000.00000000
   HostMin:   100.64.0.1           01100100.01 000000.00000000.00000001
   HostMax:   100.127.255.254      01100100.01 111111.11111111.11111110
   Broadcast: 100.127.255.255      01100100.01 111111.11111111.11111111
   Hosts/Net: 4194302               Class A
   
   1. Requested size: 50 hosts
   Netmask:   255.255.255.192 = 26 11111111.11111111.11111111.11 000000
   Network:   100.64.0.0/26        01100100.01000000.00000000.00 000000
   HostMin:   100.64.0.1           01100100.01000000.00000000.00 000001
   HostMax:   100.64.0.62          01100100.01000000.00000000.00 111110
   Broadcast: 100.64.0.63          01100100.01000000.00000000.00 111111
   Hosts/Net: 62                    Class A
   
   Needed size:  64 addresses.
   Used network: 100.64.0.0/26
   ```

7. Вывести все записи из arp таблицы.\
**Linux**:
   ```
   root@ubu18:~# arp -e
   Address                  HWtype  HWaddress           Flags Mask            Iface
   192.168.1.12             ether   a8:a1:59:16:4d:84   C                     enp0s3
   gpon.net                 ether   a3:8d:9f:b3:1c:af   C                     enp0s3
   192.168.1.33             ether   cc:2d:e0:00:f8:c5   C                     enp0s3
   
   ИЛИ
   
   root@ubu18:~# ip neigh
   192.168.1.12 dev enp0s3 lladdr a8:a1:59:16:4d:84 REACHABLE
   192.168.1.1 dev enp0s3 lladdr a3:8d:9f:b3:1c:af STALE
   192.168.1.33 dev enp0s3 lladdr cc:2d:e0:00:f8:c5 STALE
   fe80::1 dev enp0s3 lladdr a3:8d:9f:b3:1c:af router STALE
   ```
   **Windows**:
   ```
   PS C:\Users\Andy> arp -a

   Интерфейс: 192.168.1.12 --- 0xa
     адрес в Интернете      Физический адрес      Тип
     192.168.1.1           a3-8d-9f-b3-1c-af     динамический
     192.168.1.13          08-00-27-20-f3-ac     динамический
     192.168.1.33          cc-2d-e0-00-f8-c5     динамический
   ```

   Очистить ARP таблицу на Linux можно командой `ip neigh flush all` на Windows `arp -d *`.  Удалить нужный IP из arp
Linux `arp -d <IP_ADDRESS>` или `ip neigh del <IP_ADDRESS> dev <IF_NAME>`, Windows `arp -d <IP_ADDRESS>`.

---

# Домашнее задание к занятию "3.6. Компьютерные сети. Лекция 1"
1. HTTP GET запрос к stackoverflow.com/questions вернул код `403 Forbidden`. Код `403` означает что сервер понимает
запрос, но у выполняемого его клиента ограничен доступ к указанному ресурсу. В данном случаи блокируется по ip адресу.
Вывод команды telnet:
   ```
   root@ubu18:~# telnet stackoverflow.com 80
   Trying 151.101.65.69...
   Connected to stackoverflow.com.
   Escape character is '^]'.
   GET /questions HTTP/1.0
   HOST: stackoverflow.com
   
   HTTP/1.1 403 Forbidden
   Connection: close
   Content-Length: 1920
   Server: Varnish
   Retry-After: 0
   Content-Type: text/html
   Accept-Ranges: bytes
   Date: Sat, 12 Nov 2022 09:55:17 GMT
   Via: 1.1 varnish
   X-Served-By: cache-fra-eddf8230062-FRA
   X-Cache: MISS
   X-Cache-Hits: 0
   X-Timer: S1668246917.170776,VS0,VE1
   X-DNS-Prefetch-Control: off

       <div class="wrapper">
                   <div class="msg">
                           <h1>Access Denied</h1>
                           <p>This IP address (46.138.50.132) has been blocked from access to our services. 
                           <p>Method: block</p>
                           <p>Time: Sat, 12 Nov 2022 09:55:17 GMT</p>
                           <p>URL: stackoverflow.com/questions</p>
                   </div>
           </div>
   </body>
   </html>Connection closed by foreign host.
   ```

2. HTTP GET запрос к stackoverflow.com через браузер вернул код `301 Moved Permanently`. Означает что запрошенный адрес
был перенесён и надо переходить на URL указанный в заголовке `location`. В данном случаи на схему https.
Дольше всего выполнялся запрос `https://stackoverflow.com/`. (Скриншот по дополнительной ссылке).

3. На текущую сессию ip адрес `46.138.50.132`, определён с использованием сервиса `2ip.ru`.

4. Провайдер `PJSC MGTS` номер автономной системы `AS25513`.\
Вывод whois:
   ```
   root@ubu18:~# whois -h whois.ripe.net 46.138.50.132
   
   % Information related to '46.138.0.0/16AS25513'
   
   route:          46.138.0.0/16
   descr:          Moscow Local Telephone Network (PJSC MGTS)
   descr:          Moscow, Russia
   origin:         AS25513
   mnt-by:         MGTS-USPD-MNT
   created:        2010-11-29T19:47:08Z
   last-modified:  2020-01-13T10:32:12Z
   source:         RIPE
   ```
5. Трассировка маршрута до ip адреса 8.8.8.8.\
Вывод команды `traceroute`:
   ```
   root@ubu18:~# traceroute -nA 8.8.8.8
   traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
    1  192.168.1.1 [*]  15.558 ms  15.576 ms  15.571 ms
    2  100.115.0.1 [*]  26.710 ms  26.736 ms  26.729 ms
    3  212.188.1.6 [AS8359]  26.775 ms  26.768 ms  26.761 ms
    4  212.188.1.5 [AS8359]  26.699 ms *  26.711 ms
    5  72.14.223.74 [AS15169]  26.704 ms 72.14.223.72 [AS15169]  26.697 ms 72.14.223.74 [AS15169]  26.588 ms
    6  108.170.250.34 [AS15169]  26.541 ms 108.170.250.83 [AS15169]  12.244 ms 108.170.250.99 [AS15169]  7.569 ms
    7  142.251.238.82 [AS15169]  30.224 ms 142.250.238.214 [AS15169]  34.869 ms 142.251.238.82 [AS15169]  34.826 ms
    8  72.14.232.190 [AS15169]  34.819 ms 142.251.238.68 [AS15169]  34.812 ms 142.251.237.146 [AS15169]  34.766 ms
    9  216.239.47.167 [AS15169]  34.795 ms 72.14.237.201 [AS15169]  34.820 ms 216.239.58.53 [AS15169]  34.780 ms
   10  * * *
   11  * * *
   12  * * *
   13  * * *
   14  * * *
   15  * * *
   16  * * *
   17  * * *
   18  8.8.8.8 [AS15169]  24.732 ms * *
   ```

6. Среднее значение RTT за 61 пакет было хуже всего с AS15169 ip 216.239.48.224. (Скриншот по дополнительной ссылке).

7. Результаты получены командой `dig +trace dns.google`. \
   Зону `dns.google.` держат серверы:
   ```
   dns.google.             10800   IN      NS      ns4.zdns.google.
   dns.google.             10800   IN      NS      ns2.zdns.google.
   dns.google.             10800   IN      NS      ns3.zdns.google.
   dns.google.             10800   IN      NS      ns1.zdns.google.
   ```
   Записи типа A для имени `dns.google.`:
   ```
   dns.google.             900     IN      A       8.8.4.4
   dns.google.             900     IN      A       8.8.8.8
   ```
   
   Записи типа A для DNS серверов зоны `dns.google.`:
   ```
   ns4.zdns.google.        6455    IN      A       216.239.38.114
   ns3.zdns.google.        6450    IN      A       216.239.36.114
   ns2.zdns.google.        6448    IN      A       216.239.34.114
   ns1.zdns.google.        6446    IN      A       216.239.32.114
   ```

8. Результат получен командами `dig -x 8.8.8.8` и `dig -x 8.8.4.4`: \
   К ip адресам 8.8.8.8, 8.8.4.4 привязано доменное имя `dns.google.` об этом свидетельствуют PTR записи 
   `8.8.8.8.in-addr.arpa.` и `4.4.8.8.in-addr.arpa.` в обратной зоне. 

---

# Домашнее задание к занятию "3.5. Файловые системы"
1. Sparse (разряженный) файл - это такой файл у которого последовательности нулевых байт заменяются так называемые
дырами `Hole`, информация о дырах записывается в метаданных файловой системы и по факту указанные последовательности не
занимают места на диске, хотя размер файла будет отображаться с учётом этих ненулевых последовательностей.
2. Файлы являющееся жесткими ссылками на один объект будут иметь одинаковые права доступа и владельцев, так получается
потому что жёсткая ссылка это ссылка на индексный дескриптор `inode` в которым хранятся права доступа и владелец, а в
данном случаи файлы ссылаются на один и тот же `inode`.
3. Новая ВМ с дополнительными двумя не размеченными дисками создана:
    ```
    root@vagrant:~# lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop /snap/core20/1328
    loop1                       7:1    0 67.2M  1 loop /snap/lxd/21835
    loop2                       7:2    0 43.6M  1 loop /snap/snapd/14978
    sda                         8:0    0   64G  0 disk
    ├─sda1                      8:1    0    1M  0 part
    ├─sda2                      8:2    0  1.5G  0 part /boot
    └─sda3                      8:3    0 62.5G  0 part
       └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm  /
    sdb                         8:16   0  2.5G  0 disk
    sdc                         8:32   0  2.5G  0 disk
    ```

4. Процесс разбивки первого диска утилитой `fdisk`:
    ```
    root@vagrant:~# fdisk /dev/sdb
    #---------------------DISK 2G----------------------------
    Command (m for help): n
    Partition type
       p   primary (0 primary, 0 extended, 4 free)
       e   extended (container for logical partitions)
    Select (default p): p
    Partition number (1-4, default 1): 1
    First sector (2048-5242879, default 2048): 2048
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (2048-5242879, default 5242879): +2G
    
    Created a new partition 1 of type 'Linux' and of size 2 GiB.
    #---------------------DISK 511M----------------------------
    Command (m for help): n
    Partition type
       p   primary (1 primary, 0 extended, 3 free)
       e   extended (container for logical partitions)
    Select (default p):
   
    Using default response p.
    Partition number (2-4, default 2):
    First sector (4196352-5242879, default 4196352):
    Last sector, +/-sectors or +/-size{K,M,G,T,P} (4196352-5242879, default 5242879):
   
    Created a new partition 2 of type 'Linux' and of size 511 MiB. 
    ```
   
5. Перенос таблицы разделов с первого на второй диск утилитой `sfdisk`:
    ```
    root@vagrant:~# sfdisk -d /dev/sdb | sfdisk /dev/sdc
    Checking that no-one is using this disk right now ... OK
   
    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
   
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Script header accepted.
    >>> Created a new DOS disklabel with disk identifier 0xc14b955e.
    /dev/sdc1: Created a new partition 1 of type 'Linux' and of size 2 GiB.
    /dev/sdc2: Created a new partition 2 of type 'Linux' and of size 511 MiB.
    /dev/sdc3: Done.
   
    New situation:
    Disklabel type: dos
    Disk identifier: 0xc14b955e
    
    Device     Boot   Start     End Sectors  Size Id Type
    /dev/sdc1          2048 4196351 4194304    2G 83 Linux
    /dev/sdc2       4196352 5242879 1046528  511M 83 Linux
   
    The partition table has been altered.
    Calling ioctl() to re-read partition table.
    Syncing disks.
    ```

6. Сборка программного RAID 1 2х2Гб:
   ```
   root@vagrant:~# mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
   mdadm: size set to 2094080K
   Continue creating array? y
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md1 started.
   
   root@vagrant:~# cat /proc/mdstat
   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
   md1 : active raid1 sdc1[1] sdb1[0]
         2094080 blocks super 1.2 [2/2] [UU]
   
   unused devices: <none>
   ```

7. Сборка программного RAID 0 2х511 Мб:
   ```
   root@vagrant:~# mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
   mdadm: chunk size defaults to 512K
   mdadm: Defaulting to version 1.2 metadata
   mdadm: array /dev/md0 started.
   
   root@vagrant:~# cat /proc/mdstat
   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
   md0 : active raid0 sdc2[1] sdb2[0]
         1042432 blocks super 1.2 512k chunks
   
   md1 : active raid1 sdc1[1] sdb1[0]
         2094080 blocks super 1.2 [2/2] [UU]
   ```

8. Создание PV LVM на блочных устройствах массивов:
   ```
   root@vagrant:~# pvcreate /dev/md0
     Physical volume "/dev/md0" successfully created.
   
   root@vagrant:~# pvcreate /dev/md1
     Physical volume "/dev/md1" successfully created.
   
   root@vagrant:~# pvs
     PV         VG        Fmt  Attr PSize    PFree
     /dev/md0             lvm2 ---  1018.00m 1018.00m
     /dev/md1             lvm2 ---    <2.00g   <2.00g
     /dev/sda3  ubuntu-vg lvm2 a--   <62.50g   31.25g
   ```

9. Создание общей VG:
   ```
   root@vagrant:~# vgcreate vg_r0_r1 /dev/md0 /dev/md1
     Volume group "vg_r0_r1" successfully created

      root@vagrant:~# vgs
     VG        #PV #LV #SN Attr   VSize   VFree
     ubuntu-vg   1   1   0 wz--n- <62.50g 31.25g
     vg_r0_r1    2   0   0 wz--n-  <2.99g <2.99g
   ```

10. Создание LV на 100 Мб:
   ```
   root@vagrant:~# lvcreate -n lv_test1 -L 100M vg_r0_r1 /dev/md0
     Logical volume "lv_test1" created.

   root@vagrant:~# lvs -o +devices
     LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
     ubuntu-lv ubuntu-vg -wi-ao---- <31.25g                                                     /dev/sda3(0)
     lv_test1  vg_r0_r1  -wi-a----- 100.00m                                                     /dev/md0(0)
   ```

11. Создание файловой системы на LV 100 Мб:
   ```
   root@vagrant:~# mkfs.ext4 /dev/mapper/vg_r0_r1-lv_test1
   mke2fs 1.45.5 (07-Jan-2020)
   Creating filesystem with 25600 4k blocks and 25600 inodes
   
   Allocating group tables: done
   Writing inode tables: done
   Creating journal (1024 blocks): done
   Writing superblocks and filesystem accounting information: done
   ```

12. Монтирование файловой системы:
   ```
   root@vagrant:~# mkdir /mnt/tmp

   root@vagrant:~# mount /dev/mapper/vg_r0_r1-lv_test1 /mnt/tmp

   root@vagrant:~# df -hT /mnt/tmp
   Filesystem                    Type  Size  Used Avail Use% Mounted on
   /dev/mapper/vg_r0_r1-lv_test1 ext4   93M   72K   86M   1% /mnt/tmp
   ```

13. Скачивание файла:
   ```
   root@vagrant:~# cd /mnt/tmp
   root@vagrant:/mnt/tmp# wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O test.gz

   root@vagrant:/mnt/tmp# ll
   total 22772
   drwxr-xr-x 3 root root     4096 Nov 10 05:01 ./
   drwxr-xr-x 3 root root     4096 Nov 10 04:59 ../
   drwx------ 2 root root    16384 Nov 10 04:57 lost+found/
   -rw-r--r-- 1 root root 23292824 Nov 10 03:53 test.gz
   ```

14. Вывод команды `lsblk`:
   ```
   root@vagrant:/mnt/tmp# lsblk
   NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
   loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
   loop1                       7:1    0 43.6M  1 loop  /snap/snapd/14978
   loop2                       7:2    0 67.8M  1 loop  /snap/lxd/22753
   loop3                       7:3    0   48M  1 loop  /snap/snapd/17336
   loop4                       7:4    0 67.2M  1 loop  /snap/lxd/21835
   loop5                       7:5    0 63.2M  1 loop  /snap/core20/1695
   sda                         8:0    0   64G  0 disk
   ├─sda1                      8:1    0    1M  0 part
   ├─sda2                      8:2    0  1.5G  0 part  /boot
   └─sda3                      8:3    0 62.5G  0 part
     └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
   sdb                         8:16   0  2.5G  0 disk
   ├─sdb1                      8:17   0    2G  0 part
   │ └─md1                     9:1    0    2G  0 raid1
   └─sdb2                      8:18   0  511M  0 part
     └─md0                     9:0    0 1018M  0 raid0
       └─vg_r0_r1-lv_test1   253:1    0  100M  0 lvm   /mnt/tmp
   sdc                         8:32   0  2.5G  0 disk
   ├─sdc1                      8:33   0    2G  0 part
   │ └─md1                     9:1    0    2G  0 raid1
   └─sdc2                      8:34   0  511M  0 part
     └─md0                     9:0    0 1018M  0 raid0
       └─vg_r0_r1-lv_test1   253:1    0  100M  0 lvm   /mnt/tmp
   ```

15. Тестирование целостности файла `test.gz`:
   ```
   root@vagrant:/mnt/tmp# gzip -t test.gz
   
   root@vagrant:/mnt/tmp# echo $?
   0
   ```

16. Перемещение выделеных экстендов с PV Raid0 на PV Raid1:
   ```
   root@vagrant:/mnt/tmp# pvmove /dev/md0 /dev/md1
     /dev/md0: Moved: 24.00%
     /dev/md0: Moved: 100.00%
   
   root@vagrant:/mnt/tmp# lvs -o +devices
     LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert Devices
     ubuntu-lv ubuntu-vg -wi-ao---- <31.25g                                                     /dev/sda3(0)
     lv_test1  vg_r0_r1  -wi-ao---- 100.00m                                                     /dev/md1(0)   
   ```

17. Пометить диск в массиве как `faulty`:
   ```
   root@vagrant:/mnt/tmp# mdadm /dev/md1 -f /dev/sdb1
   mdadm: set /dev/sdb1 faulty in /dev/md1
   
   root@vagrant:/mnt/tmp# cat /proc/mdstat
   Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
   md0 : active raid0 sdc2[1] sdb2[0]
         1042432 blocks super 1.2 512k chunks
   
   md1 : active raid1 sdc1[1] sdb1[0](F)
         2094080 blocks super 1.2 [2/1] [_U]
   
   unused devices: <none>
   ```

18. Вывод команды `dmesg -T`:
   ```
   ...
   [Thu Nov 10 05:20:27 2022] md/raid1:md1: Disk failure on sdb1, disabling device.
                              md/raid1:md1: Operation continuing on 1 devices.
   ```

19. Тестирование файла `test.gz`:
   ```
   root@vagrant:/mnt/tmp# gzip -t test.gz
   
   root@vagrant:/mnt/tmp# echo $?
   0
   ```


---

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
