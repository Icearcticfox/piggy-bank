Preparing to Interview

Resources:

1. https://github.com/Swfuse/devops-interview?tab=readme-ov-file

2. https://github.com/rmntrvn/adm_linux_ops_questions

---

## Общее

### У вас есть компьютер. Вы нажали на кнопку включения. Расскажите максимально подробно, что происходит, до загрузки ОС.

Подается сигнал о подаче питания, запускается BIOS/UEFI (программа подготовки к загрузке ОС). Загрузчик проверяет целостность своей программы, инициализирует устройства. После успешного прохождения тестов BIOS ищет загрузчик ОС:

- ищется загрузочный сектор (MBR)
- считывается код из этого раздела и управление передается ему,
- этот код ищет активный раздел ("system partition"), в первом разделе которого находится загрузочный код GRUB,

- GRUB загружает и выполняет образы ядра и initrd,
- передает управление ядру,
- ядро монтируется в файловую систему и выполняет процесс init,
- init загружает программы уровней выполнения (runlevel) из `/etc/rc.d/rc*.d/`.

Пример программ:

- `S12syslog` — запуск демона syslog,
- `S80sendmail` — запуск демона sendmail.

Таким образом, syslog будет запущен перед sendmail.

Источник: https://habr.com/ru/post/518972/

### Открыли linux консоль, ввели curl www.tinkoff.ru - нажали энтер. Что происходит, максимально подробно.

curl — утилита для взаимодействия с хостами по протоколам: FTP, FTPS, HTTP, HTTPS, TFTP, SCP, SFTP, Telnet, DICT, LDAP, POP3, IMAP и SMTP.

Без дополнительных параметров curl выполняется с методом GET по протоколу HTTP (уровень L7). Перед этим:

- происходит разрешение DNS имени в IP-адрес по протоколу DNS,

- запрос уходит на DNS-сервер, далее по цепочке — к корневым DNS и авторитетным,

- получив IP, устанавливается соединение по TCP (трехстороннее рукопожатие),

- используется стек TCP/IP и таблицы маршрутизации,

- далее отправляется HTTP-запрос на порт 80,

- получаем ответ от сервера.


### Что такое LoadAverage?

LoadAverage — средняя загрузка CPU за 1, 5 и 15 минут.

- **Что означает?** Процент утилизируемого времени от общего времени простоя.

- **В чем измеряется?** Измеряется в тиках (единицы времени CPU), сколько тиков отдано на выполнение процессов. Если > 100%, значит есть очередь из ожидающих процессов.

- **Какое нормальное значение?** До 1 на 1 CPU (1.0 на одно ядро).

- **Если LA = 1000 — это нормально?** Нет, это плохо, если только не 1000 ядер в системе.

- **Что влияет на LA?** Например, iowait.

Высокие значения wa и LA часто говорят о D-state (ожидание ввода/вывода), может быть связано с дисками, сетью, USB, сокетами и др.


Упрощенная модель состояний процесса в Linux:

- **D** — ожидание ввода/вывода

- **R** — выполняется

- **S** — спящий, ждет события

- **T** — остановлен

- **Z** — зомби


Посмотреть процессы: `ps aux`

Если wa > 10-30%, желательно найти причину.

Источник: https://firstvds.ru/technology/nagruzka-na-server-opredelenie-prichin

### Кто и при каких условиях может менять группу у файла?

Команда: `chown`

- **Требуется:** либо быть владельцем файла, либо иметь права root.


#### Пример:

```
-rw------- 1 user1 user1 147746 мар 27 12:19 somefile
```

- `chown user1:user2 somefile`

- `chown user1:www-data somefile`

- **Если не root:** сработает, если user1 состоит в этих группах.

- **Если root:** сработает, если группы и пользователи существуют.


### Свободное место #1

`df -Th` показывает, что место есть. Но `touch file` — ошибка "No space left on device".

Причины:

- Файлы были удалены, но заняты процессами.

- Проверка: `sudo lsof / | grep deleted`

- Исчерпаны **inodes** — `df -i`

- Плохие блоки — использовать `fsck -vcck /dev/sdX`

- Ограничения файловой системы (например, FAT — макс. файл 4GB)


Источник: https://rtfm.co.ua/unix-df-i-du-raznye-znacheniya/ https://zalinux.ru/?p=3001

### Свободное место #2

Корень 100ГБ, `df` показывает занято всё, а `du -sh /*` — только 10ГБ.

Возможные причины:

- Файлы удалены, но заняты процессами.

- Найти процессы: `lsof | grep deleted`

#### Пояснение: файловые дескрипторы и inodes

- **inode** — уникальный ID файла, метаданные.

- **fd (file descriptor)** — "билет" на доступ к файлу для конкретного процесса, с конкретными правами.

- Один файл может быть открыт многими fd.

- После закрытия fd доступ к файлу теряется (если нет других открытых).


### Гипервизор

Гипервизор — это низкоуровневая оболочка (программа или аппаратная схема), обеспечивающая параллельное выполнение нескольких ОС на одном хост-компьютере.

Функции:
- изоляция ОС,
- безопасность и защита,
- управление и разделение ресурсов,
- виртуализация оборудования,
- включение/перезагрузка/выключение ВМ,
- взаимодействие между ОС (например, по сети).

Гипервизор можно считать микроядром — минимальной ОС, управляющей виртуальными машинами.

---

## GIT

### Как внести изменения в последний коммит?

Можно использовать команду `git commit` с флагом `--amend`.
### Как добавить забытые файлы в последний коммит?

Если забыли включить в коммит часть файлов, можно:

```
git add dir1
git commit

# забыли dir2:
git add dir2
git commit --amend --no-edit
```

Флаг `--no-edit` позволяет оставить прежнее сообщение коммита.
### Чем отличается git revert от git reset?

- `git revert` отменяет **один конкретный коммит**, создав новый коммит с обратными изменениями.
- `git reset` возвращает проект к прошлому состоянию, **удаляя** все последующие коммиты (если hard).

---

## Сеть

### TCP vs UDP. Разница

- **TCP** — протокол с гарантией доставки, устанавливает соединение перед передачей пакетов.
- **UDP** — не устанавливает соединение, работает быстрее, не гарантирует доставку. Используется для потокового видео, DNS и других приложений, где важна скорость.

### Как происходит TCP-handshake?

**Кратко:**
1. Клиент отправляет SYN с seq=A.
2. Сервер отвечает SYN+ACK с seq=B и ack=A+1.
3. Клиент отправляет ACK с seq=A+1 и ack=B+1.

**Подробно:**
1. Клиент отправляет сегмент с SYN и случайным seq (A).
2. Сервер запоминает seq клиента, выделяет сокет, отправляет SYN+ACK (seq=B, ack=A+1) и переходит в SYN-RECEIVED. При ошибке — RST.
3. Клиент получает SYN+ACK, запоминает seq сервера и отправляет ACK. Переходит в ESTABLISHED. Если получил RST — завершает попытку. При таймауте — повтор.
4. Сервер при получении ACK переходит в ESTABLISHED. Если нет ACK — закрывает соединение.

### Что такое таблица маршрутизации?

Это таблица, содержащая маршруты для отправки пакетов в разные подсети и сети. Используется для выбора интерфейса и следующего хопа (gateway).

**Проверка маршрута до IP 1.2.3.4:**
```bash
traceroute 1.2.3.4
ip route get 1.2.3.4
```

### IPTables: SNAT, DNAT, Маскарадинг

**Основные таблицы:**

#### 1. Filter Table
- Используется по умолчанию.
- Для фильтрации пакетов (DROP, LOG, ACCEPT, REJECT).
- Цепочки:
  - INPUT (пакеты для сервера)
  - OUTPUT (исходящие локальные)
  - FORWARD (транзитные)

#### 2. NAT Table
- Для преобразования сетевых адресов.
- Только первый пакет потока проходит через эту таблицу.
- Цепочки:
  - PREROUTING — DNAT
  - POSTROUTING — SNAT
  - OUTPUT — NAT для локально сгенерированных

#### 3. Mangle Table
- Для изменения заголовков: TOS, TTL, MARK и др.
- Цепочки:
  - PREROUTING, INPUT, FORWARD, OUTPUT, POSTROUTING

#### 4. Raw Table
- До connection tracking (state machine)
- Цепочки: PREROUTING, OUTPUT

**Цепочки IPTables:**
- PREROUTING — до маршрутизации
- INPUT — для сервера
- FORWARD — транзитные
- OUTPUT — локальные исходящие
- POSTROUTING — после маршрутизации

### Что означает запись 10.12.15.35/22?

CIDR-блок `/22`:
- Маска: `255.255.252.0`
- Диапазон: `10.12.12.0 – 10.12.15.255`
- Пример частной сети с 1024 адресами, 64 подсети.

### DNS

**Структура записи DNS (RR):**
- NAME — домен
- TYPE — тип записи (A, AAAA, MX, CNAME...)
- CLASS — тип сети (обычно IN)
- TTL — срок жизни в кэше
- RDLEN — длина данных
- RDATA — содержимое

**Типы записей:**
- A — IPv4 адрес
- AAAA — IPv6 адрес
- CNAME — псевдоним (каноническое имя)
- MX — почтовый обменник
- NS — DNS сервер зоны
- PTR — обратная запись IP → имя
- SOA — начальная запись зоны
- SRV — серверы сервисов (например, для Jabber, Active Directory)

### Сетевые утилиты

#### Проверка открытых портов и сокетов
```bash
ss -tlpn
```

#### Проверка сетевых интерфейсов
```bash
ip a
```

#### Проверка маршрутов
```bash
ip route
```

### NetCat (nc)

**Проверка порта:**
```bash
nc -vn 192.168.1.100 12345
```

**Сканирование портов:**
```bash
nc -vnz 192.168.1.100 20-24
```

Источник: https://habr.com/ru/post/336596/

### Nmap

**Поиск всех хостов в подсети:**
```bash
nmap -sP 192.168.1.0/24
nmap -sn 192.168.1.0/24
```

### Tcpdump

**Пример:**
```bash
tcpdump -i any -s0
```
- `-i` — интерфейс
- `-s` — размер захвата пакета (0 — весь)


---

## Docker

### Что такое Docker? Как он устроен? На каких технологиях основывается?

Docker — это платформа контейнеризации, позволяющая запускать приложения в изолированной среде (контейнере).

**Технологии:**
- cgroups и namespaces (пространства имён) для изоляции
- union файловые системы (OverlayFS)
- контейнерный движок containerd/runc

### Пространства имён, используемые Docker:
- **pid** — изоляция процессов
- **net** — отдельные сетевые интерфейсы
- **ipc** — управление IPC-ресурсами (взаимодействие процессов)
- **mnt** — управление точками монтирования
- **uts** — имя хоста и домена (hostname)

### Разница между Docker и VMware

- Docker — уровень ОС (использует ядро хоста, быстрая и лёгкая изоляция)
- VMware — полноценная виртуализация (каждая ВМ — своя ОС, медленнее, ресурсоёмко)

### Зачем нужен Docker? Какие проблемы решает?
- Решает проблему "работает у меня, не работает у тебя"
- Позволяет создавать воспроизводимую среду
- Быстрое развёртывание и масштабирование приложений

### Писали Dockerfile?
Да.

### Основные директивы Dockerfile
- `FROM` — базовый образ
- `RUN` — выполнение команд в контейнере при сборке
- `COPY` / `ADD` — копирование файлов
- `CMD` / `ENTRYPOINT` — команда запуска
- `EXPOSE` — открытие портов
- `ENV` — переменные окружения
- `WORKDIR` — рабочая директория

### Разница между Dockerfile и docker-compose

- **Dockerfile** — инструкция для создания образа
- **docker-compose.yml** — инструмент для описания и запуска многоконтейнерных приложений (описывает сервисы, сети, тома)

### Как перенести docker image с одной машины на другую без registry?
```bash
docker save myimage > image.tar
scp image.tar user@remote:/tmp/
docker load < image.tar
```
Или:
```bash
docker export <container> > file.tar
# и далее docker import
```

### Best practices по написанию Dockerfile и безопасности контейнеров
- Использовать минимальные образы (например, `alpine`)
- Указывать конкретные версии пакетов
- Не использовать root внутри контейнера
- Минимизировать количество слоёв
- Удалять временные файлы после установки пакетов
- Не хранить секреты в образах
- Использовать `USER` для запуска приложений
- Ограничивать доступ к хосту (AppArmor, seccomp, read-only FS)

### Сетевые драйверы Docker

- **bridge** — дефолтная сеть, контейнеры в одной подсети, могут общаться между собой через виртуальный bridge-интерфейс
- **host** — контейнер использует сетевой стек хоста
- **macvlan** — каждому контейнеру назначается отдельный MAC-адрес, прямой доступ к сети
- **overlay** — сеть между несколькими хостами (используется в Swarm)
- **swarm** — кластерная сеть для контейнеров, работающих в Swarm-режиме

---

## Bash

### Обработка access логов (CSV): timestamp, status, url, user-agent

#### Количество уникальных URL:
```bash
cut -d',' -f3 access.csv | sort | uniq | wc -l
```

#### Количество запросов на каждый URL:
```bash
cut -d',' -f3 access.csv | sort | uniq -c | sort -nr
```

#### Количество 400-404 по каждому URL:
```bash
awk -F',' '$2 ~ /^40[0-4]$/ {print $3}' access.csv | sort | uniq -c | sort -nr
```

### Что делает `set -eu -o pipefail`?

Используется в начале bash-скриптов для надёжности:
- `set -e` — завершает скрипт, если любая команда завершилась с ошибкой.
- `set -u` — завершает скрипт, если используется необъявленная переменная.
- `set -o pipefail` — если одна из команд в пайпе завершилась с ошибкой, скрипт завершится.
- `set -x` (дополнительно) — выводит команды в stdout перед выполнением (для отладки).

### Как выполнить одну и ту же команду на 50 серверах?

**Варианты:**
- С помощью `ssh` в цикле:
```bash
for host in $(cat hosts.txt); do
  ssh user@$host 'команда' &
done
wait
```

- Использовать `pssh` (parallel-ssh):
```bash
pssh -h hosts.txt -l user -i 'команда'
```

- Использовать Ansible:
```bash
ansible all -i hosts.ini -m shell -a 'команда'
```

- Использовать `tmux`, `dsh`, `fabric` и другие инструменты массового управления.


## Балансировщики нагрузки

### Зачем нужны?
- Распределение нагрузки между приложениями
- Высокая доступность и отказоустойчивость
- Масштабируемость приложений

### Nginx

#### Ошибки по статус-кодам
- **5xx** — ошибка на стороне сервера (например, 500)
- **4xx** — ошибка на стороне клиента (например, 400, 404, 413 — превышен размер запроса)

#### HTTP-методы, изменяющие состояние
- `POST`, `PUT`, `DELETE`

#### Как Nginx решает проблему C10K?

За счёт событийно-ориентированной архитектуры:
- неблокирующая модель
- master + многопроцессная модель workers
- каждый worker — однопоточный, обрабатывает тысячи соединений
- минимизация переключений контекста (в отличие от Apache)

#### Важные параметры
```nginx
worker_processes auto;
worker_connections 1024;
# max_clients = worker_processes * worker_connections
```

#### Как выбирается location?
Порядок:
1. `=` — точное совпадение
2. `^~` — приоритетный префикс
3. `~` / `~*` — регулярные выражения (учитывает/не учитывает регистр)
4. Без модификаторов — префиксные совпадения

#### Как дебажить location?
- Логи: `access.log`, `error.log`
- Временный вывод переменных через `return`, `add_header`
- Консоль разработчика браузера
- Проверка фактического URI и проксируемого пути

#### Что реально приходит на приложение?
Проверить на стороне приложения (например, на `localhost:3000`) фактический URL запроса, заголовки и путь (`X-Forwarded-For`, `X-Real-IP`, `Host`)

#### Преимущества Nginx перед Apache
- Лучшая производительность при отдаче статики (x2.5)
- Эффективная архитектура (event loop против процессов)
- Меньшее потребление памяти
- Часто используется как frontend прокси к Apache/php-fpm и др.

#### Могут ли работать вместе?
Да. Пример связки:
- Nginx — фронтенд, отдает статику, проксирует
- Apache — бэкенд, генерирует динамику

### HAProxy
- Высокопроизводительный L4/L7-балансировщик
- Поддержка TCP и HTTP
- Поддержка ACL, health checks, sticky sessions
- Часто используется в продакшене как фронтенд балансер

### Envoy
- Прокси и сервис-меш от Lyft
- Поддерживает HTTP/2, gRPC, TLS termination
- Используется в Istio
- Расширенные возможности маршрутизации и мониторинга

### Google Cloud Load Balancer
- Балансировка на уровне L4 и L7
- Автоматическое масштабирование и Anycast IP
- Интеграция с Cloud CDN, Cloud Armor
- Управляется через GCP Console или `gcloud`

### AWS Load Balancers

#### Classic Load Balancer (CLB)
- Устаревший, L4/L7

#### Application Load Balancer (ALB)
- L7 балансировка (HTTP/HTTPS)
- Поддержка path-based, host-based routing

#### Network Load Balancer (NLB)
- L4 балансировка (TCP/UDP)
- Высокая пропускная способность и низкая задержка

Обычно используется вместе с Auto Scaling и ECS/EKS

## Прокси vs Реверс-прокси

### Что такое прокси (forward proxy)?

Прокси-сервер действует от имени клиента:
- Клиент отправляет запрос не напрямую к целевому серверу, а через прокси.
- Прокси перенаправляет запрос и возвращает ответ обратно клиенту.
- Пример: сотрудник офиса выходит в интернет через корпоративный прокси-сервер.

**Используется для:**
- Контроля доступа (фильтрация)
- Кеширования
- Анонимизации
- Обхода блокировок

### Что такое реверс-прокси (reverse proxy)?

Реверс-прокси действует от имени сервера:
- Клиент делает запрос на один публичный адрес.
- Реверс-прокси принимает запрос и перенаправляет его одному из внутренних серверов.
- Ответ возвращается клиенту от имени прокси.

**Используется для:**
- Балансировки нагрузки
- SSL termination
- Кеширования
- Ограничения доступа и аутентификации
- Защиты внутренних сервисов
### Сравнение
| Характеристика        | Прокси                     | Реверс-прокси               |
|------------------------|----------------------------|-----------------------------|
| Работает для кого?     | От имени клиента           | От имени сервера            |
| Кто знает о нём?       | Клиент                     | Сервер (а клиент — нет)     |
| Основная задача        | Доступ к внешним ресурсам  | Защита и маршрутизация к внутренним ресурсам |
| Пример                 | Squid                      | Nginx, HAProxy, Envoy       |

