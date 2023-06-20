# Инструкция (РУС)

## Загрузите репозиторий:
```bash
git clone https://github.com/XackiGiFF/Docker-Bedrock-Launcher.git
cd Docker-Bedrock-Launcher
```

Для чистой сборки самого нового Minecrfat с мультиядром 1.18.0-1.20.0 используйте:

```bash
docker-compose up --build
```

Это установит последнюю версию из репозитория https://github.com/NetherGamesMC/PocketMine-MP.git

Сборщик использует PHP версии для PM4 и PM5.
Сам Dockerfile, собирающий PHP, лежит в папке ./php данного репозитория.
PHP версии берутся из репозитория https://github.com/pmmp/PHP-Binaries.git с пометкой веток:
![image](https://github.com/mpe-corp/MPEServer/assets/29034010/2932a6ea-3d95-4607-9497-dc2ae7a84127)

Для API 5.0.0+ используйте - PHP 8.2 +JIT, +GB:
/home/mcpe/pm5/bin/php7/bin/php

Для API 4.0.0+ используйте - PHP 8.0 +JIT, +GB:
/home/mcpe/pm4/bin/php7/bin/php

Запуск сервера в докер контейнере выполняется за счет запуска скрипта:
 - On Linux
```bash
./start-docker.sh
```
- On Windows
```powershell
./start-docker.cmd
```

Для Linux вы можете запустить screen и внутри виртуального окна запустить ./start-docker.sh

Содержимое файла ./start-docker.sh:
```bash
docker run -it --rm \
--name mcpe-lobby \
--privileged \
-p 19132:19132 \
-p 19132:19132/udp \
-p 19133:19133  \
-p 19133:19133/udp \
-v ./lobby/:/home/mcpe/lobby \
 xackigiff/mcpe-php-8:latest \
 ./lobby/start.sh -l
```

В общем и целом вы можете расположить папку со своим сервером (сборкой) так:
```
./lobby/
./start-docker.sh
```
Внутри папки отредактируйте ваш файл ./start.sh
Замените ваш путь ./bin/php7/bin/php на один из двух вариантов:
../pm5/bin/php7/bin/php
../pm4/bin/php7/bin/php
В зависимости от ядра используйте необходимый путь.

Так же обратите внимание на номер порта, который используете.
Необходимо менять порты в файлах:
./lobby/server.properties
./docker-compose.yml
./start-docker.yml

Вы можете запускать неограниченное количество серверов, для этого используйте start-docker.sh:
```bash
docker run -it --rm \
--name mcpe-lobby \
--privileged \
-p 19132:19132 \
-p 19132:19132/udp \
-p 19133:19133  \
-p 19133:19133/udp \
-v ./server/:/home/mcpe/server \
 xackigiff/mcpe-php-8:latest \
 ./server/start.sh -l
```
И свою папку server со своей сборкой. Так же обращайте внимание на файл start.sh, как уже говорил, необходимо использовать путь к php внутри docker и следите за номерами портов.
