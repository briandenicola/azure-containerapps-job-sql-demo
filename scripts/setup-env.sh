SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
INFRA_PATH=$(realpath "${SCRIPT_DIR}/../infrastructure")
APP_PATH=$(realpath "${SCRIPT_DIR}/../app")

export APP_NAME=$(terraform -chdir=${INFRA_PATH} output -raw APP_NAME)
export RG=$(terraform -chdir=${INFRA_PATH} output -raw RESOURCE_GROUP)
export SQL_SERVER_NAME=$(terraform -chdir=${INFRA_PATH} output -raw SQL_SERVER_NAME)
export SQL_SERVER_FQDN=$(terraform -chdir=${INFRA_PATH} output -raw SQL_SERVER_FQDN)
export MANAGED_IDENTITY_NAME=$(terraform -chdir=${APP_PATH} output -raw MANAGED_IDENTITY_NAME)