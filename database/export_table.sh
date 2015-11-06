#!/bin/bash

EXPORT_DIR=/tmp/export
DBNAME=myDB

sudo -u postgres rm -Rf ${EXPORT_DIR}
sudo -u postgres mkdir ${EXPORT_DIR}
schema_list=$1

for schema in ${schema_list}
do
  echo #### ${schema} ####

  for relname in `sudo -u postgres psql -t -d ${DBNAME} -c "SELECT table_name FROM information_schema.tables WHERE table_schema = '${schema}';"`
  do
    if [ ${relname} != 'wrongTable' ];
    then
      echo ${relname}
      sudo -u postgres pgsql2shp -f ${EXPORT_DIR}/${schema}_${relname}.shp ${DBNAME} ${schema}.${relname} 2>&1 |tee -a output.log
    fi;
  done;
  
done;

