#!/bin/bash

# Скрипт импорта XML файла в Битрикс
# Базовые настройки в файле etc/config
# Дополнительный импорт rezerv.zip (нет в штатных импортах Битрикса)

cd "$(dirname "$0")"
source etc/config

URI="$SITE/bitrix/admin/1c_exchange.php"
COOK='data/cookiefile.txt'
FILE='data/rezerv.zip'
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
  curl -s -c $COOK -b $COOK -X POST --data-binary @- $URI'?type=catalog&mode=file&filename=rezerv.zip' -H "Authorization: Basic $BASIC_AUTH" -H 'Content-Type: application/octet-stream' -H 'Expect:' --trace-ascii log/debug.txt < $FILE > log/03-file.txt
}

function stepFile {
  curl -s -c $COOK -b $COOK $URI'?type=catalog&mode=rezerv&filename='$REZERV_FILENAME -H "Authorization: Basic $BASIC_AUTH" > log/step.txt
  echo
  cat log/step.txt | iconv -f $CHARSET_IN -t $CHARSET_OUT
  echo
}

function run {
  declare -a FILES=("56647_1e50536b-6283-11dc-bd86-00001a1a02c3_00000054381_2016-04-29_Soglasovanietovarovvputi_0.HTML" "56647_1e50536b-6283-11dc-bd86-00001a1a02c3_00000054381_2016-04-29_Soglasovanietovarovvputi_0.HTML" "56663_2a09ee2b-8891-11d9-aa78-505054503030_00000054397_2016-04-29_Soglasovanietovarovvputi_0.HTML" "56670_4313dbce-8891-11d9-aa78-505054503030_00000054404_2016-04-29_Soglasovanietovarovvputi_1.HTML")
  for REZERV_FILENAME in "${FILES[@]}"; do
    echo $REZERV_FILENAME
    echo
    stepFile
  done
}

init
upload
run

echo
