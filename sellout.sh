#!/bin/bash

#
# Это - тестовый скрипт для проверки работоспособности API
# Для проверки работоспособности API под управлением NodeJS @see api/goods/test-api.sh
#

cd "$(dirname "$0")"

source etc/config

# Библиотека цветов
# Сброс
Color_Off='\e[0m'       # Text Reset
Red='\e[0;31m'          # Red
Green='\e[0;32m'        # Green
Yellow='\e[0;33m'       # Yellow
Blue='\e[0;34m'         # Blue
Purple='\e[0;35m'       # Purple
Cyan='\e[0;36m'         # Cyan
White='\e[0;37m'        # White
UCyan='\e[4;36m'        # Cyan

echo -e $UCyan"Server: "$SITE$Color_Off"\n"

function assert {
	SUBSTR=`echo "$1" | grep "$2"`
	if [ $? != 0 ]; then
		echo -e $Red"Expected: $2"$Color_Off
	fi
}

function testBasicAuth {
	echo -e $Cyan"Test Basic Auth"$Color_Off

	RESP=`curl -is --user $LOGIN_PASS_SELLOUT $SITE/api/login/`
	assert "$RESP" 'HTTP/1.1 200 OK'
	assert "$RESP" 'success'
}

function ApiSelloutDebug {
	echo -e $Cyan"API: /api/sellout/"$Color_Off
	cat data/sellout.json | curl -is --user $LOGIN_PASS_SELLOUT -d @- $SITE/api/sellout/json/
}

# Базовые проверки

testBasicAuth

ApiSelloutDebug
