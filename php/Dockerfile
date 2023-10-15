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
    re2c libtool-bin screen mc nano

RUN useradd -d ${HOME} -m ${USER} && passwd -d ${USER} && adduser ${USER} sudo

WORKDIR /home/mcpe

RUN cd ${HOME}


# FOR NEW ADN LOBBY PM5
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
RUN cd ${PM5}
RUN ls -l
RUN chmod +x ./compile.sh
RUN ./compile.sh -P5 -j 2 -g -J || FAILED=true \
if [ $FAILED ] \
    then ./send-error.sh \
fi

# FOR OLD VERSION PM4
WORKDIR /home/mcpe/
RUN cd /home/mcpe/
RUN git clone https://github.com/pmmp/PHP-Binaries.git -b php-8.0-latest
RUN mkdir pm4
RUN cp ./PHP-Binaries/compile.sh ./pm4/compile.sh
RUN rm -Rf ./PHP-Binaries
WORKDIR /home/mcpe/pm4/
RUN cd ${PM4}
RUN ./compile.sh -P4.1.0 -j 12 -g || FAILED=true \
if [ $FAILED ] \
    then ./send-error.sh \
fi
RUN cd ..

WORKDIR /home/mcpe

RUN rm ./pm4/compile.sh
RUN rm ./pm5/compile.sh

RUN ln -s ${PM5}/bin/php7/bin/php /usr/bin/php
RUN echo "phar.readonly=0" >> ${PM5}/bin/php7/bin/php.ini
RUN echo "phar.readonly=0" >> ${PM4}/bin/php7/bin/php.ini

# Adding composer PM5 support
RUN curl -sS https://getcomposer.org/installer | /usr/bin/php \
  && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

#Chown dir, set user mcpe

CMD ["/bin/sh"]
