FROM ubuntu:jammy

RUN apt-get update && apt-get upgrade -y \
    && apt-get install apt-utils -y

RUN apt-get install git -y
RUN apt-get install libc6-dev -y

ENV USER=mcpe
ENV HOME=/home/mcpe
ENV PM5=/home/mcpe/pm5
ENV PM4=/home/mcpe/pm4

RUN apt install --no-install-recommends -y ca-certificates \
    apt-transport-https \
    sudo curl make gcc wget \
    autoconf automake m4 \
    bzip2 bison g++ cmake pkg-config \
    re2c libtool-bin screen mc nano \
#Add new xz-utils cause very need, LoL
    xz-utils

RUN useradd -d ${HOME} -m ${USER} && passwd -d ${USER} && adduser ${USER} sudo


# FOR NEW ADN LOBBY PM5
WORKDIR /home/mcpe
RUN git clone https://github.com/pmmp/PHP-Binaries.git -b php-8.2-latest
WORKDIR /home/mcpe/PHP-Binaries
RUN ls -lA
RUN git status
RUN git checkout -b php-8.2-latest d5c2d1669f89
WORKDIR /home/mcpe/
RUN ls -l
RUN mkdir pm5
RUN cp -Rf ./PHP-Binaries/* ./pm5/
RUN rm -Rf ./PHP-Binaries
WORKDIR /home/mcpe/pm5/
RUN ls -l
RUN chmod +x ./compile.sh
RUN ./compile.sh -P5 -j 12 -g -J
RUN cat ./install.log
RUN rm -Rf ./install_data

# FOR OLD VERSION PM4
WORKDIR /home/mcpe/
RUN git clone https://github.com/pmmp/PHP-Binaries.git -b php-8.1-latest
WORKDIR /home/mcpe/PHP-Binaries
RUN ls -lA
RUN git status
RUN git checkout -b php-8.1-latest
WORKDIR /home/mcpe/
RUN ls -l
RUN mkdir pm4
RUN cp -Rf ./PHP-Binaries/* ./pm4/
RUN rm -Rf ./PHP-Binaries
WORKDIR /home/mcpe/pm4/
RUN ./compile.sh -P4.20.0 -j 12 -g
RUN cat ./install.log
RUN rm -Rf ./install_data

WORKDIR /home/mcpe
RUN rm ./pm4/compile.sh
# RUN rm ./pm5/compile.sh

RUN ln -s ${PM5}/bin/php7/bin/php /usr/bin/php

RUN echo "phar.readonly=0" >> ${PM5}/bin/php7/bin/php.ini
RUN echo "phar.readonly=0" >> ${PM4}/bin/php7/bin/php.ini

RUN chmod +x ${PM5}/bin/php7/bin/php
RUN chmod +x ${PM4}/bin/php7/bin/php

RUN ${PM5}/bin/php7/bin/php -v
RUN ${PM4}/bin/php7/bin/php -v

# Adding composer PM5 support
RUN curl -sS https://getcomposer.org/installer | /usr/bin/php \
  && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

#Chown dir, set user mcpe

CMD ["/bin/sh"]
