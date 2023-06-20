@echo off
TITLE MPE-Lobby Server Minecraft Bedrock
docker run -it --rm --name mcpe-lobby --privileged -p 19132:19132 -p 19132:19132/udp -p 19133:19133 -p 19133:19133/udp -v .\lobby\:/home/mcpe/lobby xackigiff/mcpe-php-8:latest /home/mcpe/lobby/start.sh -l