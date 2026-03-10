#!/bin/bash
set -e

SUBSCRIPTION_ID="<your-subscription-id>"
RESOURCE_GROUP="SecureInfraRG"
VNET_NAME="SecureVNet"
DB_SUBNET="DBSubnet"
WEB_SUBNET="WebSubnet"
DBADMINS_ID="<DBAdminsObjectID>"
WEBADMINS_ID="<WebAdminsObjectID>"

# Create test users
az ad user create --display-name "Test Web User" --user-principal-name testweb@hildaisi2016gmail.onmicrosoft.com --password "P@ssword123!"
az ad user create --display-name "Test DB User" --user-principal-name testdb@hildaisi2016gmail.onmicrosoft.com --password "P@ssword123!"

# Add users to groups
WEBUSER_ID=$(az ad user show --id testweb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv)
DBUSER_ID=$(az ad user show --id testdb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv)

az ad group member add --group WebAdmins --member-id $WEBUSER_ID
az ad group member add --group DBAdmins --member-id $DBUSER_ID

# Assign roles
az role assignment create --assignee $DBADMINS_ID --role Reader --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME/subnets/$DB_SUBNET
az role assignment create --assignee $WEBADMINS_ID --role Contributor --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME/subnets/$WEB_SUBNET
