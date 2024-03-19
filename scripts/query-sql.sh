#!/bin/bash

while (( "$#" )); do
  case "$1" in
    -h|--help)
      echo "Usage: ./set-sql.sh 
      "
      exit 0
      ;;
    --) 
      shift
      break
      ;;
    -*|--*=) 
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
  esac
done

source $(dirname $0)/setup-env.sh

SQL_AUTH_METHOD=ActiveDirectoryManagedIdentity
SQL_DB_NAME=todo 
SQL_SERVER_FQDN=`echo $CONN_STR | awk -F[\;:] '{ print $2 }'`
AZURE_USERNAME=`echo $CONN_STR | awk -F[\;=] '{ print $6 }'`

echo "Simple Query. . ."
sqlcmd --authentication-method=${SQL_AUTH_METHOD} -U ${AZURE_USERNAME} -S ${SQL_SERVER_FQDN} -d ${SQL_DB_NAME} --query "SELECT * FROM todos;"
