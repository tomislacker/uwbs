#!/bin/bash

IPADDR=$1

getWhoisCIDR ()
{
	local thisIP=$1
	whois $thisIP | grep -m1 '^CIDR:' | cut -d: -f2
}

getWhoisInetNum ()
{
	local thisIP=$1
	whois $thisIP | grep -m1 '^inetnum:' | cut -d: -f2 | egrep -o "[0-9\.]+"
}

getCIDRFromRange ()
{
	local startIP=$1
	local endIP=$2
	ipcalc ${startIP} - ${endIP} | tail -1
#	cidrBits=`echo "<?php echo (32 - log(( 1 + ( ip2long('${startIP}') ^ ip2long('${endIP}') )),2)).PHP_EOL; ?>" | php`
#	echo "`echo "<?php echo long2ip(ip2long('${startIP}') - 1).PHP_EOL; ?>" | php`/${cidrBits}"
}

testCIDR=$(getWhoisCIDR ${IPADDR})
if [[ ${#testCIDR} -eq 0 ]]; then
	ipStartEnd=($(getWhoisInetNum ${IPADDR}))
	getCIDRFromRange ${ipStartEnd[0]} ${ipStartEnd[1]}
else
	echo $testCIDR
fi

