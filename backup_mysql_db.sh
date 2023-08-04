#!/bin/bash

# Необходимые переменные
DB_USER="your_db_user"
DB_PASSWORD="your_db_password"
DB_NAME="your_db_name"
BACKUP_DIR="/path/to/backup/directory"
OPTS="-v --add-drop-database --add-locks --create-options --disable-keys --extended-insert --single-transaction --quick --set-charset --routines --events --triggers --comments --quote-names --order-by-primary --hex-blob"
LOG="/var/log/mysql/backup.log"

# Создание имени файла резервной копии с текущей датой и временем
BACKUP_FILE="${BACKUP_DIR}/backup_$(date +%Y%m%d%H%M%S).sql"

# Создание резервной копии базы данных MySQL
mysqldump ${OPTS} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${BACKUP_FILE}

# Проверка целостности резервной копии
BEGIN=`head -n 1 ${BACKUP_FILE} | grep ^'-- MySQL dump' | wc -l`
END=`tail -n 1 ${BACKUP_FILE} | grep ^'-- Dump completed' | wc -l`
if [ "$BEGIN" == "1" ];then
if [ "$END" == "1" ];then
    echo `${BACKUP_FILE} is OK >> $LOG
else
    echo `${BACKUP_FILE} is corrupted >> $LOG
    /usr/bin/rm ${BACKUP_FILE}
fi
else
    echo `${BACKUP_FILE} is corrupted >> $LOG
    /usr/bin/rm ${BACKUP_FILE}
fi
