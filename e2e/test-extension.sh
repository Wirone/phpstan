#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

git clone https://github.com/phpstan/$1.git extension
cd extension

if [[ "$PHP_VERSION" == "7.1" || "$PHP_VERSION" == "7.2" ]]; then
  if [[ "$1" == "phpstan-mockery" ]]; then
    composer require --dev phpunit/phpunit:'^7.5.20' mockery/mockery:^1.3 --update-with-dependencies
  elif [[ "$1" == "phpstan-doctrine" ]]; then
    composer require --dev phpunit/phpunit:'^7.5.20' doctrine/orm:^2.7.5 doctrine/lexer:^1.0 --no-update --update-with-dependencies
  else
    composer require --dev phpunit/phpunit:'^7.5.20' --update-with-dependencies
  fi;

  composer install --no-interaction
else
  composer install --no-interaction
fi;

cp ../phpstan.phar vendor/phpstan/phpstan/phpstan.phar
cp ../phpstan vendor/phpstan/phpstan/phpstan
cp ../bootstrap.php vendor/phpstan/phpstan/bootstrap.php

make tests
make phpstan
