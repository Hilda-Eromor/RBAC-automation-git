#!/bin/bash
set -e

# Real subscription ID from your JSON
SUBSCRIPTION_ID="7d69cb51-bea6-4579-a183-a1dbc8572d21"
RESOURCE_GROUP="SecureInfraRG"
VNET_NAME="SecureVNet"
DB_SUBNET="DBSubnet"
WEB_SUBNET="WebSubnet"

# Actual Object IDs for your groups
DBADMINS_ID="72016581-d115-4686-96dd-a52d7c7c9cd4"
WEBADMINS_ID="1d30472b-bb4a-4822-af79-3effe0983902"

# Remove role assignments
az role assignment delete --assignee $DBADMINS_ID --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME/subnets/$DB_SUBNET || echo "DBAdmins role not found"
az role assignment delete --assignee $WEBADMINS_ID --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP/providers/Microsoft.Network/virtualNetworks/$VNET_NAME/subnets/$WEB_SUBNET || echo "WebAdmins role not found"

# Remove users from groups and delete them
WEBUSER_ID=$(az ad user show --id testweb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv || true)
DBUSER_ID=$(az ad user show --id testdb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv || true)

if [ -n "$WEBUSER_ID" ]; then
    az ad group member remove --group WebAdmins --member-id $WEBUSER_ID || echo "Not in WebAdmins"
    az ad user delete --id testweb@hildaisi2016gmail.onmicrosoft.com || echo "Web user not found"
fi

if [ -n "$DBUSER_ID" ]; then
    az ad group member remove --group DBAdmins --member-id $DBUSER_ID || echo "Not in DBAdmins"
    az ad user delete --id testdb@hildaisi2016gmail.onmicrosoft.com || echo "DB user not found"
fi

