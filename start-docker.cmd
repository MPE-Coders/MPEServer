@echo off
TITLE MPE-Lobby Server Minecraft Bedrock
docker run -it --rm --name mcpe-lobby --privileged -p 19132:19132/udp -p 19132:19132 -p 19133:19133/udp -p 19133:19133 -v .\lobby\:/home/mcpe/lobby xackigiff/mcpe-servers:latest ./lobby/start.sh -l