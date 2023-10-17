FROM xackigiff/mcpe-php-image:latest

# ENV HOME_DIR = /home/mcpe
# ENV PM_VERSION = 5
# ENV PM_DIR = ${HOME_DIR}pm${PM_VERSION}
# ENV PHP_VERSION = 8.2-latest
# ENV GIT_HASH = d5c2d1669f89

ARG HOME_DIR
ARG PM_VERSION
ARG PHP_VERSION
ARG GIT_HASH

ENV HOME_DIR $HOME_DIR
ENV PM_VERSION = $PM_VERSION
ENV PM_DIR = ${HOME_DIR}pm${PM_VERSION}
ENV PHP_VERSION = $PHP_VERSION
ENV GIT_HASH = $GIT_HASH


# FOR NEW ADN LOBBY PM5
WORKDIR ${HOME_DIR}/
RUN git clone https://github.com/pmmp/PHP-Binaries.git -b php-${PHP_VERSION}
WORKDIR ${HOME_DIR}/PHP-Binaries
RUN ls -lA
RUN git status
RUN git checkout -b php-${PHP_VERSION} ${GIT_HASH}
WORKDIR ${HOME_DIR}/
RUN ls -l
RUN cp -Rf ./PHP-Binaries/* ${PM_DIR}/
RUN rm -Rf ./PHP-Binaries
WORKDIR ${PM_DIR}/
RUN ls -l
RUN chmod +x ./compile.sh
RUN ./compile.sh -P5 -j 12 -g -J
RUN cat ./install.log
RUN rm -Rf ./install_data

RUN echo "phar.readonly=0" >> ${PM_DIR}/bin/php7/bin/php.ini

RUN chmod +x ${PM_DIR}/bin/php7/bin/php

RUN ${PM_DIR}/bin/php7/bin/php -v

RUN ln -s ${PM5}/bin/php7/bin/php /usr/bin/php-${PHP_VERSION}

# Adding composer PM5 support
RUN curl -sS https://getcomposer.org/installer | /usr/bin//usr/bin/php-${PHP_VERSION} \
  && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer-${PHP_VERSION}

#Chown dir, set user mcpe

CMD ["/bin/sh"]