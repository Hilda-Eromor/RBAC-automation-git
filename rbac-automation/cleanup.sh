#!/bin/bash
set -e

SUBSCRIPTION_ID="<your-subscription-id>"
RESOURCE_GROUP="SecureInfraRG"
VNET_NAME="SecureVNet"
DB_SUBNET="DBSubnet"
WEB_SUBNET="WebSubnet"
DBADMINS_ID="<DBAdminsObjectID>"
WEBADMINS_ID="<WebAdminsObjectID>"

# Remove role assignments
az role assignment delete --assignee $DBADMINS_ID --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME/subnets/$DB_SUBNET
az role assignment delete --assignee $WEBADMINS_ID --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME/subnets/$WEB_SUBNET

# Remove users from groups and delete them
WEBUSER_ID=$(az ad user show --id testweb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv || true)
DBUSER_ID=$(az ad user show --id testdb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv || true)

if [ -n "$WEBUSER_ID" ]; then
  az ad group member remove --group WebAdmins --member-id $WEBUSER_ID
  az ad user delete --id testweb@hildaisi2016gmail.onmicrosoft.com
fi

if [ -n "$DBUSER_ID" ]; then
  az ad group member remove --group DBAdmins --member-id $DBUSER_ID
  az ad user delete --id testdb@hildaisi2016gmail.onmicrosoft.com
fi
