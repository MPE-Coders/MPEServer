FROM xackigiff/mcpe-php-8:latest

ENV HOME=/home/mcpe
ENV PHP=/home/mcpe/pm5/bin/php7/bin/php 

WORKDIR /home/mcpe

RUN cd ${HOME}

RUN whoami

RUN mkdir multicore

WORKDIR /app/multicore
RUN cd ${HOME}/multicore

RUN git clone https://github.com/NetherGamesMC/PocketMine-MP.git .

#Clear Docker Image, delete build tools
RUN apt-get purge ca-certificates apt-transport-https git make gcc wget autoconf automake m4 g++ cmake pkg-config re2c libtool-bin -y
RUN apt-get autoremove --purge -y && apt-get autoclean -y && apt-get clean -y
RUN rm -rf /var/lib/{apt,dpkg,git}

RUN chown -Rf mcpe:mcpe /app/multicore
RUN chown -Rf mcpe:mcpe /home/mcpe

USER mcpe

RUN composer install
RUN composer make-server

USER root
RUN find * | grep -v PocketMine-MP.phar | xargs rm -Rf
USER mcpe

WORKDIR /home/mcpe
RUN cd /home/mcpe
RUN mkdir lobby

RUN mv /app/multicore/PocketMine-MP.phar /home/mcpe/PocketMine-MP.phar