#!/bin/bash

# Скрипт импорта JSON файла в Битрикс
# Базовые настройки в файле etc/config

FILE_TO_IMPORT='PlanPrih.json'

cd "$(dirname "$0")"
source etc/config

URI="http://$SITE/bitrix/admin/1c_exchange.php"
COOK='data/cookiefile.txt'
FILE="data/$FILE_TO_IMPORT"

STEP_CONTINUE=1
CHARSET_IN='cp1251'   # кодировка сайта
CHARSET_OUT='utf-8'   # кодировка консоли
BASIC_AUTH=`echo -n "$AUTH_LOGIN:$AUTH_PASS" | base64`

function init {
  echo 'Init'
  curl -s -c $COOK $URI'?type=catalog&mode=checkauth' -H "Authorization: Basic $BASIC_AUTH" > log/01-checkauth.txt
  curl -s -c $COOK -b $COOK $URI'?type=catalog&mode=init' -H "Authorization: Basic $BASIC_AUTH" > log/02-init.txt
}

function upload {
  echo 'Upload file'
  curl -s -c $COOK -b $COOK -X POST --data-binary @- $URI'?type=catalog&mode=file&filename='$FILE_TO_IMPORT -H "Authorization: Basic $BASIC_AUTH" -H 'Content-Type: application/octet-stream' -H 'Expect:' --trace-ascii log/debug.txt < $FILE > log/03-file.txt
}

function step {
  curl -s -c $COOK -b $COOK $URI'?type=catalog&mode=import&filename='$FILE_TO_IMPORT -H "Authorization: Basic $BASIC_AUTH" > log/step.txt
  if grep -q progress log/step.txt ; then
    STEP_CONTINUE=1
  else
    STEP_CONTINUE=0
  fi
  echo
  cat log/step.txt | iconv -f $CHARSET_IN -t $CHARSET_OUT
  echo
}

function run {
  while [[ $STEP_CONTINUE == "1" ]]; do
    step
  done
}

init
upload
run

echo
