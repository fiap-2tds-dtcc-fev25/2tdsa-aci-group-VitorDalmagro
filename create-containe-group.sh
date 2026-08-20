#!/usr/bin/env bash

set -Eeuo pipefail
set -x

export ACR_NAME=moneyhubrm566052
export ACR_SERVER=${ACR_NAME}.azurecr.io
export MYSQL_ROOT_PASSWORD=$(az keyvault secret show --vault-name kv-moneyhub-rm566052 --name mysql-root-password --query value --output tsv)
export MYSQL_DATABASE=dv-dimdim
export MYSQL_USER=$(az keyvault secret show --vault-name kv-moneyhub-rm566052 --name mysql-user --query value --output tsv)
export MYSQL_PASSWORD=$(az keyvault secret show --vault-name kv-moneyhub-rm566052 --name mysql-password --query value --output tsv)
export SPRING_DATASOURCE_URL=$(az keyvault secret show --vault-name kv-moneyhub-rm566052 --name spring-datasource-url --query value --output tsv)
export SPRING_DATASOURCE_USERNAME=$MYSQL_USER
export SPRING_DARASOURCE_PASSWORD=$MYSQL_PASSWORD
ADMIN_USERNAME=$(az acr credential show --name ${ACR_NAME} \
                                        --resource-group rg-money-hub \
                                        --query username --output tsv)
ADMIN_PASSWORD=$(az acr credential show --name ${ACR_NAME} \
                                        --resource-group rg-money-hub \
                                 --query passwords[0].value --output tsv)
az container create \
  --resource-group rg-money-hub \
  --file aci-deploy.yaml \
  --output table
