FROM xackigiff/mcpe-php-image:latest

# ENV HOME_DIR = /home/mcpe
# ENV PM_VERSION = 5
# ENV PM_DIR = ${HOME_DIR}pm${PM_VERSION}
# ENV PHP_VERSION = 8.2-latest
# ENV GIT_HASH = d5c2d1669f89

WORKDIR /app

COPY build.sh .

# Mount the secret to /run/secrets:
RUN --mount=type=secret,id=HOME_DIR \
    --mount=type=secret,id=PM_VERSION \
    --mount=type=secret,id=PMMP_API \
    --mount=type=secret,id=PHP_VERSION \
    --mount=type=secret,id=GIT_HASH \
    export HOME_DIR=$(cat /run/secrets/HOME_DIR) && \
    export PM_VERSION=$(cat /run/secrets/PM_VERSION) && \
    export PMMP_API=$(cat /run/secrets/PMMP_API) && \
    export PHP_VERSION=$(cat /run/secrets/PHP_VERSION) && \
    export GIT_HASH=$(cat /run/secrets/GIT_HASH) && \
    export PM_DIR = $(cat /run/secrets/HOME_DIR)pm$(cat /run/secrets/PM_VERSION) && \
    ./build.sh

CMD ["/bin/sh"]
