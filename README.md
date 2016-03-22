# Описание

Bash-cкрипт импорта XML файла в Битрикс

# Настройка

Скопировать `etc.dist` в `etc`, `data.dist` в `data`

Подправить `etc/config`, поместить свой файл выгрузки в `data`, изменить в скрипт `FILE` на новый источник.

# Запуск

```
chmod +x ./bitrix-import.sh
./bitrix-import.sh
```

На выходе получается вот что:

```
Init
Upload file

progress
Распаковка архива завершена.

progress
Временные таблицы удалены.

progress
Временные таблицы созданы.

progress
Обработано 21.69% файла.

progress
Обработано 67.21% файла.

progress
Файл импорта прочитан.

progress
Временные таблицы проиндексированы.

progress
Метаданные импортированы успешно.

progress
Группы импортированы.

progress
Деактивация/удаление групп завершено.

progress
Обработано 1231 из 5484 элементов.

progress
Обработано 5484 из 5484 элементов.

progress
Загрузка элементов завершена.

progress
Обработано 5484 из 5484 элементов.

progress
Деактивация/Удаление элементов завершены.

success
Импорт успешно завершен.
```