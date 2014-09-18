#!/usr/bin/env bash
#
# Deploy to Azure, which requires some shell magic to make things happy
#

# Are the azure tools installed
# if [ `azure -v` ]

# Subscription
echo -n "Retrieving subscription..."
export AZURE_SUBSCRIPTION="`azure account show | grep ID | awk '{ print $3 }'`"
echo "done ($AZURE_SUBSCRIPTION)."

# Download management certificate
echo -n "Retrieving management certificate..."
export AZURE_MANAGEMENT_CERT="`azure account cert export | grep 'exported to' | awk '{ print $5 }'`"
echo "done. ($AZURE_MANAGEMENT_CERT)"

# Make SSH Key Pair
echo -n "Making ssh key pair for login..."
openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 -keyout NitrogenPrivateKey.key -out NitrogenCert.pem >& /dev/null 2>&1
chmod 600 NitrogenPrivateKey.key
export NITROGEN_CERT="NitrogenCert.pem"
export NITROGEN_KEY="NitrogenPrivateKey.key"
echo "done."

# Build the vm
echo "Provisioning..."
vagrant up --provider azure
echo -n "done."