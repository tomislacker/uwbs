#!/bin/bash

BACKUP_APPEND=".bak"

thisVMDK=$1
newMB=$2

if [ ! -f "${thisVMDK}" ]; then
	echo "vmdk \"${thisVMDK}\" does not exist..." 1>&2
	exit 1
fi

vmdkDir=`dirname "${thisVMDK}"`
thisVDI=`basename "${thisVMDK}" .vmdk`.vdi

echo "Using ${vmdkDir} for files..."
echo -e "\t${thisVDI}"
echo "Making new VMDK ${newMB} MBytes..."

echo "Making VDI..."
VBoxManage clonehd "${thisVMDK}" "${thisVDI}" --format vdi
echo "Modifying VDI..."
VBoxManage modifyhd "${thisVDI}" --resize ${newMB}
echo "Backing up original VMDK..."
mv "${thisVMDK}" "${thisVMDK}${BACKUP_APPEND}"
echo "Converting VDI back to VMDK"
VBoxManage clonehd "${thisVDI}" "${thisVMDK}" --format vmdk

