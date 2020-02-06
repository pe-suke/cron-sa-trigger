#!/bin/bash

export RESOURCE_SUFFIX=<Prefered Suffix Here>
export TARGET_SA_NAMES_WITH_RG=<Resouce Group Name>/<Your Stream Analytics Job Name>,<Resouce Group Name>/<Your Stream Analytics Job Name>

export RG_NAME=rg-azfun-cron-$RESOURCE_SUFFIX
export STORAGE_NAME=azfuncronstore$RESOURCE_SUFFIX
export FUNCTION_NAME=azfun-cron-sa-trigger-$RESOURCE_SUFFIX
export LOCATION=japaneast

RG_IS_EXISTED=$(az group exists -n $RG_NAME)

if [ $RG_IS_EXISTED != "true" ]; then
  az group create --name $RG_NAME --location $LOCATION
else
  echo "Resource Group: "${RG_NAME}" is alreday exisetd. Skip creating the resource groups"
fi

ST_IS_EXISTED=$(az storage account check-name --name $STORAGE_NAME | jq -r ".nameAvailable")

if [ $ST_IS_EXISTED = "true" ]; then
  az storage account create \
    --name $STORAGE_NAME \
    --location $LOCATION \
    --resource-group $RG_NAME \
    --sku Standard_LRS
else
    echo "A storage account as functions store: "${STORAGE_NAME}" is alreday in use. Skip creating the storage account."
fi

az functionapp show --name $FUNCTION_NAME --resource-group $RG_NAME

if [ $? != 0 ]; then
  az functionapp create \
    --name $FUNCTION_NAME \
    --storage-account $STORAGE_NAME \
    --consumption-plan-location $LOCATION \
    --resource-group $RG_NAME
else
  echo "Function is already created. Skip creating that."
fi

SUBSCRIPTION_ID=$(az account show \
  --query "id"\
  --output tsv)

az functionapp config appsettings set \
  --name $FUNCTION_NAME \
  --resource-group $RG_NAME \
  --settings SUBSCRIPTION_ID=$SUBSCRIPTION_ID \
  TARGET_SA_NAMES_WITH_RG=$TARGET_SA_NAMES_WITH_RG

az webapp identity assign \
  --name $FUNCTION_NAME \
  --resource-group $RG_NAME

yarn install
func azure functionapp publish $FUNCTION_NAME --javascript