FROM xackigiff/mcpe-php:pm4

FROM xackigiff/mcpe-php:pm5

WORKDIR /home/mcpe/pm4
COPY --from=0 /home/mcpe/pm4 .

RUN echo "phar.readonly=0" >> /home/mcpe/pm4/bin/php7/bin/php.ini

RUN chmod +x /home/mcpe/pm4/bin/php7/bin/php

RUN /home/mcpe/pm4/bin/php7/bin/php -v

WORKDIR /home/mcpe/pm5

RUN echo "phar.readonly=0" >> /home/mcpe/pm5/bin/php7/bin/php.ini

RUN chmod +x /home/mcpe/pm5/bin/php7/bin/php

RUN /home/mcpe/pm5/bin/php7/bin/php -v

CMD ["/bin/sh"]