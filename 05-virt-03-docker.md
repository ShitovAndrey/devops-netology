# Домашнее задание к занятию "3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"
 * Задача 1. Ссылка на образ прилагается.
    ``` dockerfile
    #Dockerfile домашнего задания
    
    FROM nginx:1.23.3
    LABEL "author"="AndyS"
    LABEL "build"="for_netology"
    
    COPY index.html /usr/share/nginx/html
    
    CMD ["nginx", "-g", "daemon off;"]
    ```
    
    ``` bash
    #Содержимое директории
    root@ubu18:~/docker/Dokerfile2# ls -1
    Dockerfile
    index.html
    
    #Команда сборки образа
    docker build --tag redlinx/nginx:1.23.3-netology .
    
    #Авторизация в Docker Hub Registry
    root@ubu18:~/docker/Dokerfile2# docker login
    Username: username
    Password:
    
    Login Succeeded
    
    #Загрузка образа в Registry
    root@ubu18:~/docker/Dokerfile2# docker push redlinx/nginx:1.23.3-netology
    The push refers to repository [docker.io/redlinx/nginx]
    64d1ab7c1f05: Pushed
    3ea1bc01cbfe: Mounted from library/nginx
    a76121a5b9fd: Mounted from library/nginx
    2df186f5be5c: Mounted from library/nginx
    21a95e83c568: Mounted from library/nginx
    81e05d8cedf6: Mounted from library/nginx
    4695cdfb426a: Mounted from library/nginx
    1.23.3-netology: digest: sha256:b726c1585b1ed65fe1bb59002899f206b091e2e55cfd942c9ee2cdf5260001cf size: 1777
    ```

 * Задача 2
   - Высоконагруженное монолитное java веб-приложение;
     ```
     Надо смотреть на архитектуру монолита и особенности обновления. Если это не stateless приложение и пишит данные на
     диск, то размещаем на виртуальной машине, если требуется максимальная производительность от дисковой подсистемы,
     то физический сервер. Скорее всего под высоконагруженное приложение требуются все ресурсы хоста, поэтому размещать
     его в контейнере Docker, с точки зрения эффективного использования вычислительной плотности неимеет смысла.
     Если приложение поддерживает работу в несколько реплик, возможны варианты его масштабирования средствами Kubernetes,
     в т.ч. автоматически.
     ```
   - Nodejs веб-приложение;
     ```
     Для такого приложения хорошо подходит контейнеризация. Размещение в Docker позволит эффекивно использовать
     вычислительные ресурсы хоста и получить все преимущества immutable Docker images, в т.ч. возможность обновить
     приложение без DownTime. Дополнительной выгодой можно считать возможность создавать тестовые ландшафты на том же хосте. 
     ```
   - Мобильное приложение c версиями для Android и iOS;
     ```
     Контейнеризация будет хорошим решением. На одном хосте можно запустить приложение под разные платформы,
     контейнеры выполняют достаточную изоляцию окружений. База данных для этих приложений, в зависимости от нагрузки,
     стоит разместить на виртуальном или физическом сервере.
     ```
   - Шина данных на базе Apache Kafka;
     ```
     Apache Kafka - распределённый брокер сообщений, способный обрабатывать большие объемы данных. Требования к ресурсом
     CPU, RAM достаточно малы, при этом требуется большие объемы хранения данных. Такое приложение эффективно разместить
     на виртуальной машине.   
     ```
   - Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два
     logstash и две ноды kibana;
     ```
     В зависимости от нагрузки, т.к. Elasticsearch много пишет на диск, к тому же требуется размещение на разных узлах,
     лучше разместить на виртуальных или физических серверах. Для приложений logstash и kibana подайдёт контейнерное
     размещение, но надо предусмотреть размещение нод на разных хостах. В общем случаи, для унификации стоит весь стек
     ELK разместит на виртуальных серверах.
     ```
   - Мониторинг-стек на базе Prometheus и Grafana;
     ```
     Такие приложения можно размещать в контейнерах, это и делается практически во всех инсталляциях Kubernetes.
     Для Grafana и Prometheus не требуется значимых ресурсов по CPU, RAM, а также производительного хранилища, достаточно
     томов небольшого объема. 
     ```
   - MongoDB, как основное хранилище данных для java-приложения;
     ```
     Приложения MongoDB т.к. оно statefull в зависимости от профиля нагрузки, лучше разместить на виртуальной машине или
     физическом сервере. При запуске в контейнере отсутствуют преимущества данного типа размещения. 
     ```
   - Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.
     ```
     Компоненты стоит разделить по разным типам размещения. Т.к. GitLab имеет СУБД PostgreSQL, её лучше запустить
     отдельно на виртуальном или физическом сервере. Также Docker Registry как statefull приложение разместить на
     виртуальном сервере, т.к. нагрузка на дисковую подсистему не высокая. Остальные компоненты GitLab в т.ч.
     gitlab-runner разместить в контейнерах.
     ```

 * Задача 3
    ``` bash
    # Скачиваем образы CentOS и Debian
    root@ubu18:~/docker/Dokerfile2# docker pull centos:centos7.9.2009
    centos7.9.2009: Pulling from library/centos
    2d473b07cdd5: Pull complete
    
    root@ubu18:~/docker/Dokerfile2# docker pull debian:stable-20230208-slim
    stable-20230208-slim: Pulling from library/debian
    de661c304c1d: Pull complete
    
    #Создаем директорию /data (при использование --volume не обязательный пункт)
    root@ubu18:~/docker/Dokerfile2# mkdir /data
    
    #Запуск контейнера CentOS
    root@ubu18:~/docker/Dokerfile2# docker run --detach -it --name centos-netology --volume /data:/data centos:centos7.9.2009
    02591617b32a78cf73ead305b261a39776fe24781fe34aa9eeb08595967afcab
    
    #Запуск контейнера Debian
    root@ubu18:~/docker/Dokerfile2# docker run --detach -it --name debian-netology --volume /data:/data debian:stable-20230208-slim
    2138e78374646aac4a0c9f89a8591ab2c83eec8123af431843d176de6b177f49
    
    #Создание файла из CentOS контейнера
    root@ubu18:~/docker/Dokerfile2# docker exec -it centos-netology bash
    
    [root@02591617b32a /]# echo "This is Centos container." > /data/centos_file.txt
   
    [root@02591617b32a /]# exit
    exit
    
    #Создание файла на хостовой ВМ
    root@ubu18:~/docker/Dokerfile2# echo "This is host virtual machine." > /data/host_file.txt
    
    #Листинг файлов в контейнере Debian
    root@ubu18:~/docker/Dokerfile2# docker exec -it debian-netology bash
    
    root@2138e7837464:/# ls -al /data
    total 16
    drwxr-xr-x 2 root root 4096 Feb 11 11:23 .
    drwxr-xr-x 1 root root 4096 Feb 11 11:12 ..
    -rw-r--r-- 1 root root   26 Feb 11 11:20 centos_file.txt
    -rw-r--r-- 1 root root   30 Feb 11 11:23 host_file.txt
    
    root@2138e7837464:/# cat /data/*
    This is Centos container.
    This is host virtual machine.
    
    ```
 * Задача 4. Перед сборкой, пришлось в `Dockerfile` изменить строку `COPY ansbile.cfg /ansible/` на
   `COPY ansible.cfg /ansible/` и строку `pip install mitogen ansible-lint jmespath && \` на
   `pip install "packaging==20.9" mitogen ansible-lint jmespath && \`. Ссылка на образ прилогается.