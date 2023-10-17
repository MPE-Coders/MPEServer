FROM xackigiff/mcpe-php-image:latest

ARG HOME_DIR
ARG PM_VERSION
ARG PMMP_API
ARG PHP_V
ARG GIT_HASH

ENV HOME_DIR ${HOME_DIR}
ENV PM_VERSION ${PM_VERSION}
ENV PMMP_API ${PMMP_API}
ENV PM_DIR "${HOME_DIR}/pm${PM_VERSION}"
ENV PHP_V ${PHP_V}
ENV GIT_HASH ${GIT_HASH}

# FOR NEW ADN LOBBY PM5
WORKDIR ${HOME_DIR}/
RUN git clone https://github.com/pmmp/PHP-Binaries.git -b php-${PHP_V}
WORKDIR ${HOME_DIR}/PHP-Binaries
RUN ls -lA
RUN git status
RUN git checkout -b php-${PHP_V} ${GIT_HASH}
WORKDIR ${HOME_DIR}/
RUN ls -l
RUN cp -Rf ./PHP-Binaries/* "${PM_DIR}/"
RUN rm -Rf ./PHP-Binaries
WORKDIR ${PM_DIR}/
RUN ls -l
RUN chmod +x ./compile.sh
RUN ./compile.sh -P ${PMMP_API} -j 12 -g -J; exit 0;
RUN cat ./install.log
RUN rm -Rf ./install_data

RUN echo "phar.readonly=0" >> "${PM_DIR}/bin/php7/bin/php.ini"

RUN chmod +x "${PM_DIR}/bin/php7/bin/php"

RUN "${PM_DIR}/bin/php7/bin/php" -v

RUN ln -s "${PM_DIR}/bin/php7/bin/php" "/usr/bin/php-${PHP_V}"

# Adding composer PM* support
RUN curl -sS https://getcomposer.org/installer | "/usr/bin/php-${PHP_V}" \
  && chmod +x composer.phar && mv composer.phar "/usr/local/bin/composer-${PHP_V}"

#Chown dir, set user mcpe
