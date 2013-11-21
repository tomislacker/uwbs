#!/bin/bash

BIN_PREFIX=/usr/local/bin
SET_MODE=755
SET_OWNER=root
SET_GROUP=root
SET_NAME=

newBinScript_dumpConfig ()
{
	echo -e "BIN_PREFIX: '${BIN_PREFIX}'"
	echo -e "  SET_MODE: '${SET_MODE}'"
	echo -e " SET_OWNER: '${SET_OWNER}'"
	echo -e " SET_GROUP: '${SET_GROUP}'"
	echo -e "  SET_NAME: '${SET_NAME}'"
}

newBinScript_usage ()
{
	cat << EOF
	usage: $0
		[-b]			# Set prefix to /usr/local/bin]
		[-s]			# Set prefix to /usr/local/sbin]
		[-p <prefix>]	# Set prefix explicitly
		[-m <mode>]		# Set file mode explicitly (default: 755)
		[-o <user>]		# Set the owner of the new file
		[-g <user>]		# Set the group of the new file
		[-n <name>]		# Set the filename of the new file
EOF
}

errorAndDie ()
{
	local exitVal=$1
	shift
	local errMsg=$*
	echo -e "${errMsg}" 1>&2
	exit $exitVal
}

###
# Collect any command line parameters
###
while getopts ":hbsp:m:o:g:n:" opt; do
	case $opt in
		h)	newBinScript_usage ; exit 0	;;
		b)	BIN_PREFIX=/usr/local/bin	;;
		s)	BIN_PREFIX=/usr/local/sbin	;;
		p)	BIN_PREFIX=$OPTARG			;;
		m)	SET_MODE=$OPTARG			;;
		o)	SET_OWNER=$OPTARG			;;
		g)	SET_GROUP=$OPTARG			;;
		n)	SET_NAME=$OPTARG			;;
		\?)
			echo "Invalid option: -${OPTARG}" 1>&2
			echo "Run '$0 -h' for usage..." 1>&2
			exit 1
			;;
		:)
			echo "Option -${OPTARG} requires an argument." 1>&2
			echo "Run '$0 -h' for usage..." 1>&2
			exit 1
	esac
done

#newBinScript_dumpConfig
NEW_FILE_PATH="${BIN_PREFIX}/${SET_NAME}"

if [[ ${#SET_NAME} -eq 0 ]]; then
	echo "Must specify filename with -n" 1>&2
	newBinScript_usage
	exit 50
elif [ ! -d "${BIN_PREFIX}" ]; then
	echo "BIN_PREFIX='${BIN_PREFIX}' is not a directory." 1>&2
	exit 51
elif [ -f "${NEW_FILE_PATH}" ]; then
	echo "New file '${NEW_FILE_PATH}' already exists." 1>&2
	exit 52
fi

touch "${NEW_FILE_PATH}" || errorAndDie 53 "Failed to touch '${NEW_FILE_PATH}'."
chown ${SET_OWNER}:${SET_GROUP} "${NEW_FILE_PATH}" || errorAndDie 54 "Failed to chown ${SET_OWNER}:${SET_GROUP} '${NEW_FILE_PATH}'."
chmod $SET_MODE "${NEW_FILE_PATH}" || errorAndDie 55 "Failed to chmod ${SET_MODE} '${NEW_FILE_PATH}'."
vi "${NEW_FILE_PATH}"


