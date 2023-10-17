#!/bin/bash

# FOR Build PM
cd $HOME_DIR
git clone https://github.com/pmmp/PHP-Binaries.git -b php-$PHP_VERSION
cd $HOME_DIR/PHP-Binaries
ls -lA
git status
git checkout -b php-$PHP_VERSION $GIT_HASH
cd $HOME_DIR/
ls -l
cp -Rf ./PHP-Binaries/* $PM_DIR/
rm -Rf ./PHP-Binaries
cd $PM_DIR/
ls -l
chmod +x ./compile.sh
./compile.sh -P$PMMP_API -j 12 -g -J
cat ./install.log
rm -Rf ./install_data

echo "phar.readonly=0" >> $PM_DIR/bin/php7/bin/php.ini

chmod +x "$PM_DIR/bin/php7/bin/php"

$PM_DIR/bin/php7/bin/php -v

ln -s $PM5/bin/php7/bin/php /usr/bin/php-$PHP_VERSION

# Adding composer PM5 support
curl -sS https://getcomposer.org/installer | "/usr/bin//usr/bin/php-$PHP_VERSION" \
  && chmod +x composer.phar && mv composer.phar "/usr/local/bin/composer-$PHP_VERSION"

#Chown dir, set user mcpe