#!/bin/bash

# Скрипт эмуляции WS со стороны 1C

# Из нюансов – пока выпилил тег «status», «invoice» и “goodsIntransit»,  т.к. с этими механизмами работать будем иначе – но появилась секция «parents»

# FILE_TO_IMPORT='data/orders/Есть номер заявки.json'
# FILE_TO_IMPORT='data/orders/Есть родители.json'
# FILE_TO_IMPORT='data/orders/Нет родителя нет номера заявки.json'
# FILE_TO_IMPORT='data/orders/Пример массового импорта.json'
# FILE_TO_IMPORT='data/orders/Появился тег number.json'
# FILE_TO_IMPORT='data/orders/Документ с НДС.json'
FILE_TO_IMPORT='data/orders/Даты в товарах в пути.json'

cd "$(dirname "$0")"
source etc/config

URI="http://$SITE/lk/ws/orders/?test=1"

curl --user $WS_LOGIN:$WS_PASS -i -X POST --data @"$FILE_TO_IMPORT" -H "Content-Type: application/json" $URI
