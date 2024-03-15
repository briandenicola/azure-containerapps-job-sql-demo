#!/bin/bash

source $(dirname $0)/setup-env.sh

SQL_AUTH_METHOD=ActiveDirectoryDefault
SQL_DB_NAME=todo

#!/bin/bash

while (( "$#" )); do
  case "$1" in
    -u)
      export AZURE_CLIENT_ID=$2
      shift 2
      ;;
    -p)
      export  AZURE_CLIENT_SECRET=$2
      shift 2
      ;;
    -t)
      export  AZURE_TENANT_ID=$2
      shift 2
      ;;
    -i)
      MANAGED_IDENTITY_NAME=$2
      shift 2
      ;;
    -h|--help)
      echo "Usage: ./set-sql.sh -u {AZURE_CLIENT_ID} -p {AZURE_CLIENT_SECRET} -t {AZURE_TENANT_ID}
        -u: The SPN Client ID that has admin rights on the SQL Database [Required OR have ARM_CLIENT_ID set]
        -p: The SPN Client Secret [Required OR have ARM_CLIENT_SECRET set]
        -t: The SPN Tenant ID [Required OR have ARM_TENANT_ID set]
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

if [[ -z "${AZURE_CLIENT_ID}" ]]; then
    export AZURE_CLIENT_ID=${ARM_CLIENT_ID}
fi 

if [[ -z "${AZURE_TENANT_ID}" ]]; then
    export AZURE_TENANT_ID=${ARM_TENANT_ID}
fi 

if [[ -z "${AZURE_CLIENT_SECRET}" ]]; then
    export AZURE_CLIENT_SECRET=${ARM_CLIENT_SECRET}
fi 

sqlcmd --authentication-method=${SQL_AUTH_METHOD} -S ${SQL_SERVER_NAME} -d ${SQL_DB_NAME} --query "CREATE USER [${MANAGED_IDENTITY_NAME}] FROM EXTERNAL PROVIDER" 
sqlcmd --authentication-method=${SQL_AUTH_METHOD} -S ${SQL_SERVER_NAME} -d ${SQL_DB_NAME} --query "ALTER ROLE db_datareader ADD MEMBER [${MANAGED_IDENTITY_NAME}]"
sqlcmd --authentication-method=${SQL_AUTH_METHOD} -S ${SQL_SERVER_NAME} -d ${SQL_DB_NAME} --query "ALTER ROLE db_datawriter ADD MEMBER [${MANAGED_IDENTITY_NAME}]"
sqlcmd --authentication-method=${SQL_AUTH_METHOD} -S ${SQL_SERVER_NAME} -d ${SQL_DB_NAME} --query "CREATE TABLE dbo.Todos ( [Id] INT PRIMARY KEY, [Name] VARCHAR(250) NOT NULL, [IsComplete] BIT);"
sqlcmd --authentication-method=${SQL_AUTH_METHOD} -S ${SQL_SERVER_NAME} -d ${SQL_DB_NAME} --query "INSERT INTO todos VALUES ( 1, 'take out trash', 0)"