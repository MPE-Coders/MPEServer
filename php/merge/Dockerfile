FROM xackigiff/mcpe-php:pm4

FROM xackigiff/mcpe-php:pm5

FROM xackigiff/xackigiff/mcpe-php-image

WORKDIR /home/mcpe/pm4
COPY --from=0 /home/mcpe/pm4 .

WORKDIR /home/mcpe/pm5
COPY --from=1 /home/mcpe/pm5 .

CMD ["/bin/sh"]