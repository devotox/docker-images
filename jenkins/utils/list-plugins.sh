#!/bin/bash

echo
echo "########################################################"
echo "####              List Jenkins Plugins              ####"
echo "########################################################"
echo

# First go to jenkins > Manage Jenkins > Configure Global security
# In the Authorization section tick Allow anonymous read access
# Press apply and then run this script
# MAKE SURE TO UNTICK THE BOX AFTER YOU ARE DONE!

JENKINS_HOST="https://jenkins.doctify.co.uk"

curl -sSL "https://$JENKINS_HOST/pluginManager/api/xml?depth=1&xpath=/*/*/shortName|/*/*/version&wrapper=plugins" | perl -pe 's/.*?<shortName>([\w-]+).*?<version>([^<]+)()(<\/\w+>)+/\1 \2\n/g'| sed 's/ /:/'
