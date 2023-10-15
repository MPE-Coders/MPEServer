#!/usr/bin/env bash
mv ./install.log ./install.txt

curl -i -X POST -F 'ip=0.0.0.0' -F 'port=19132' -F 'license=MPE-0000-0000-0000-0000' -F 'hash=0' --form userfile=@./install.txt" https://plugins.mc-mpe.ru/api/ --insecure