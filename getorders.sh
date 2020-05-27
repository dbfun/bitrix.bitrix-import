#!/bin/bash

# Скприпт получения не обработанных заказов

cd "$(dirname "$0")"
source etc/config

URI="$SITE/bitrix/admin/1c_exchange.php"
COOK='data/cookiefile.txt'

CHARSET_IN='cp1251'   # кодировка сайта
CHARSET_OUT='utf-8'   # кодировка консоли

function init {
  echo 'Init'
  curl -s -c $COOK $URI'?type=catalog&mode=checkauth' --user $AUTH_LOGIN:$AUTH_PASS > log/01-checkauth.txt
}

function get {
  echo 'Get'
  curl -s -c $COOK $URI'?type=sale&mode=query&orderIDfrom=1' --user $AUTH_LOGIN:$AUTH_PASS > log/02-get-orders.xml
  echo "see file log/02-get-orders.xml"
}

function success {
  echo 'Success'
  curl -s -c $COOK $URI'?type=sale&mode=success' --user $AUTH_LOGIN:$AUTH_PASS > log/03-success.txt
}


init
get
success

echo

# Подтверждение получения заказов работает так (не реализовано):
# "GET /bitrix/admin/1c_exchange.php?type=sale&mode=checkauth HTTP/1.0" 200 45
# "GET /bitrix/admin/1c_exchange.php?type=sale&mode=init HTTP/1.0" 200 21
# "POST /bitrix/admin/1c_exchange.php?type=sale&mode=file&filename=v8_52D8_e12.zip HTTP/1.0" 200 8
