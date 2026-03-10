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

# Create test users
az ad user create --display-name "Test Web User" --user-principal-name testweb@hildaisi2016gmail.onmicrosoft.com --password "P@ssword1234" || echo "Test Web User already exists"
az ad user create --display-name "Test DB User" --user-principal-name testdb@hildaisi2016gmail.onmicrosoft.com --password "P@ssword1234" || echo "Test DB User already exists"

# Add users to groups
WEBUSER_ID=$(az ad user show --id testweb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv || true)
DBUSER_ID=$(az ad user show --id testdb@hildaisi2016gmail.onmicrosoft.com --query id -o tsv || true)

if [ -n "$WEBUSER_ID" ]; then
    az ad group member add --group WebAdmins --member-id $WEBUSER_ID || echo "Already in WebAdmins"
fi

if [ -n "$DBUSER_ID" ]; then
    az ad group member add --group DBAdmins --member-id $DBUSER_ID || echo "Already in DBAdmins"
fi

# Assign roles
az role assignment create --assignee $DBADMINS_ID --role Reader --scope /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP || echo "DBAdmins role assignment failed"

