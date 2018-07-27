#!/bin/bash

# Скрипт импорта XLSX файла в Битрикс (отчеты)
# Базовые настройки в файле etc/config

ZIP_FILE_TO_IMPORT='20171030_121617_fr1C_report_2017-10-30-11-54-50_6fb7747d-bf47-11e5-80d7-00155d0047b0_35113-ForProcessing__593_1085051f-5e5a-4301-b1ca-06f06826e0b8_v8_ADE9_84e.zip'

FILES_TO_IMPORT=("report_2017-10-30-11-54-50_6fb7747d-bf47-11e5-80d7-00155d0047b0_35113__593.XLSX" "report_2017-10-30-11-54-50_6fb7747d-bf47-11e5-80d7-00155d0047b0_35113-ForProcessing__593.XLSX" "report_2017-10-30-11-55-03_4313db8a-8891-11d9-aa78-505054503030_24615__593.XLSX" "report_2017-10-30-11-55-03_4313db8a-8891-11d9-aa78-505054503030_24615-ForProcessing__593.XLSX" "report_2017-10-30-11-59-33_4313db8a-8891-11d9-aa78-505054503030_24616__593.XLSX" "report_2017-10-30-11-59-33_4313db8a-8891-11d9-aa78-505054503030_24616-ForProcessing__593.XLSX" "report_2017-10-30-11-59-54_4313db8a-8891-11d9-aa78-505054503030_35114__593.XLSX" "report_2017-10-30-11-59-54_4313db8a-8891-11d9-aa78-505054503030_35114-ForProcessing__593.XLSX" "report_2017-10-30-12-00-25_4313db8a-8891-11d9-aa78-505054503030_35115__593.XLSX" "report_2017-10-30-12-00-25_4313db8a-8891-11d9-aa78-505054503030_35115-ForProcessing__593.XLSX" "report_2017-10-30-12-00-48_4313db8a-8891-11d9-aa78-505054503030_35116__593.XLSX" "report_2017-10-30-12-00-48_4313db8a-8891-11d9-aa78-505054503030_35116-ForProcessing__593.XLSX" "report_2017-10-30-12-01-05_4313db8a-8891-11d9-aa78-505054503030_35117__593.XLSX" "report_2017-10-30-12-01-05_4313db8a-8891-11d9-aa78-505054503030_35117-ForProcessing__593.XLSX" "report_2017-10-30-12-01-23_4313db8a-8891-11d9-aa78-505054503030_35118__593.XLSX" "report_2017-10-30-12-01-23_4313db8a-8891-11d9-aa78-505054503030_35118-ForProcessing__593.XLSX" "report_2017-10-30-12-01-46_4313db8a-8891-11d9-aa78-505054503030_35119__593.XLSX" "report_2017-10-30-12-01-46_4313db8a-8891-11d9-aa78-505054503030_35119-ForProcessing__593.XLSX" "report_2017-10-30-12-02-15_2a09ee2b-8891-11d9-aa78-505054503030_24618__593.XLSX" "report_2017-10-30-12-02-15_2a09ee2b-8891-11d9-aa78-505054503030_24618-ForProcessing__593.XLSX" "report_2017-10-30-12-02-47_2a09ee2b-8891-11d9-aa78-505054503030_35122__593.XLSX" "report_2017-10-30-12-02-47_2a09ee2b-8891-11d9-aa78-505054503030_35122-ForProcessing__593.XLSX" "report_2017-10-30-12-09-04_1b677745-8891-11d9-aa78-505054503030_24619__593.XLSX" "report_2017-10-30-12-09-04_1b677745-8891-11d9-aa78-505054503030_24619-ForProcessing__593.XLSX" "report_2017-10-30-12-09-34_1b677745-8891-11d9-aa78-505054503030_35123__593.XLSX" "report_2017-10-30-12-09-34_1b677745-8891-11d9-aa78-505054503030_35123-ForProcessing__593.XLSX" "report_2017-10-30-12-10-21_1b677745-8891-11d9-aa78-505054503030_24620__593.XLSX" "report_2017-10-30-12-10-21_1b677745-8891-11d9-aa78-505054503030_24620-ForProcessing__593.XLSX" "report_2017-10-30-12-10-47_1b677745-8891-11d9-aa78-505054503030_35124__593.XLSX" "report_2017-10-30-12-10-47_1b677745-8891-11d9-aa78-505054503030_35124-ForProcessing__593.XLSX" "report_2017-10-30-12-12-46_f4471be9-8890-11d9-aa78-505054503030_24621__593.XLSX" "report_2017-10-30-12-12-46_f4471be9-8890-11d9-aa78-505054503030_24621-ForProcessing__593.XLSX" "report_2017-10-30-12-13-36_f4471be9-8890-11d9-aa78-505054503030_35125__593.XLSX" "report_2017-10-30-12-13-36_f4471be9-8890-11d9-aa78-505054503030_35125-ForProcessing__593.XLSX")

cd "$(dirname "$0")"
source etc/config

URI="$SITE/bitrix/admin/1c_exchange.php"
COOK='data/cookiefile.txt'
FILE="data/$ZIP_FILE_TO_IMPORT"

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
  curl -s -c $COOK -b $COOK -X POST --data-binary @- $URI'?type=catalog&mode=file&filename='$ZIP_FILE_TO_IMPORT -H "Authorization: Basic $BASIC_AUTH" -H 'Content-Type: application/octet-stream' -H 'Expect:' --trace-ascii log/debug.txt < $FILE > log/03-file.txt
}

function step {
  echo $ARC_FILE
  curl -s -c $COOK -b $COOK $URI'?type=catalog&mode=report&filename='$ARC_FILE -H "Authorization: Basic $BASIC_AUTH" > log/step.txt
  if grep -q progress log/step.txt ; then
    STEP_CONTINUE=1
  else
    STEP_CONTINUE=0
  fi
  echo $STEP_CONTINUE
  echo
  cat log/step.txt | iconv -f $CHARSET_IN -t $CHARSET_OUT
  echo
  if [[ $STEP_CONTINUE == "1" ]]; then
    step
  fi
}

function run {
  for ARC_FILE in "${FILES_TO_IMPORT[@]}"
  do
    step
  done
}

init
upload
run

echo
