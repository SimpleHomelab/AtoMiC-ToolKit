#!/bin/bash
# Script Name: AtoMiC Ubooquity Reverse Proxy Disable.
# Author: TommyE123
# Publisher: http://www.htpcBeginner.com
# License: MIT License (refer to README.md for more details)

if sed -i "/reverseProxyPrefix/c\\  \"reverseProxyPrefix\" : \"\"," "$APPSETTINGS"; then
    echo "Updated reverseProxyPrefix in $APPSETTINGS"
fi
