#!/bin/bash

# Скрипт эмуляции WS со стороны 1C

HTTP_GET_FILENAME=1c-2018.07.26-151049-11063
SRC_FILENAME=data/"$HTTP_GET_FILENAME"

cd "$(dirname "$0")"
source etc/config

URI="$SITE/bitrix/admin/1c_exchange.php"
COOK='data/cookiefile.txt'

CHARSET_IN='cp1251'   # кодировка сайта
CHARSET_OUT='utf-8'   # кодировка консоли

function init {
  echo 'Init'
  curl -s -c $COOK $URI'?type=catalog&mode=checkauth' --user $AUTH_LOGIN:$AUTH_PASS > log/01-checkauth.txt
  curl -s -c $COOK -b $COOK $URI'?type=catalog&mode=init' --user $AUTH_LOGIN:$AUTH_PASS > log/02-init.txt
}

function upload {
  echo 'Upload file'
  curl -s -c $COOK -b $COOK -X POST --data-binary @- $URI'?type=catalog&mode=file&filename='"$HTTP_GET_FILENAME" --user $AUTH_LOGIN:$AUTH_PASS -H 'Content-Type: application/octet-stream' -H 'Expect:' --trace-ascii log/debug.txt < $SRC_FILENAME > log/03-file.txt
}

function step {
  curl -s -c $COOK -b $COOK $URI'?type=catalog&mode=report&filename='$PROCESS_FILENAME --user $AUTH_LOGIN:$AUTH_PASS > log/step.txt
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
	zipinfo -1 "$SRC_FILENAME" | while read -d $'\n' PROCESS_FILENAME; do
		echo $PROCESS_FILENAME
		STEP_CONTINUE=1
		while [[ $STEP_CONTINUE == "1" ]]; do
	    step
	  done
	done


}

init
upload
run

echo
