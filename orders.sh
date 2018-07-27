#!/bin/bash

# Скрипт эмуляции WS со стороны 1C

FILE_TO_IMPORT='data/orders/Даты в товарах в пути.json'

cd "$(dirname "$0")"
source etc/config

URI="$SITE/lk/ws/orders/?test=1"

curl --user $WS_LOGIN:$WS_PASS -i -X POST --data @"$FILE_TO_IMPORT" -H "Content-Type: application/json" $URI
