#!/bin/bash

generatePHPClass ()
{
    local SHOW_HELP=
    local CLASSNAME=
    local EXTENDS=
    local EXTENSION=".class.php"
    local NAMESPACE=""
    local DIR="$(pwd)"
    local FILENAME_LOWER=
    
    # Ensure that getopts can be called again here
    unset OPTIND
    
    # Parse command arguments
    while getopts ":hc:d:e:E:ln:" opt; do
        case $opt in
            h)  SHOW_HELP=y ;;
            c)  CLASSNAME=$OPTARG ;;
            d)  DIR="$OPTARG" ;;
            e)  EXTENDS=$OPTARG ;;
            E)  EXTENSION=$OPTARG ;;
            l)  FILENAME_LOWER=y ;;
            n)  NAMESPACE="$OPTARG" ;;
            \?)
                echo "Invalid option: -${OPTARG}" >&2
                return 1
                ;;
            :)
                echo "Option -${OPTARG} requires an argument" >&2
                return 1
                ;;
        esac
    done
    
    if [ -n "$SHOW_HELP" ]; then
        echo -e "USAGE: generatePHPClass"
        echo -e "\t-h\t\tShow this dialog"
        echo -e "\t-c <name>\tSpecify class name"
        echo -e "\t-e <name>\tClass to extend"
        echo -e "\t-E <ext>\tNew filename extension"
        echo -e "\t-l\t\tNew filename in lowercase"
        echo -e "\t-n <namespace>\tClass namespace"
        return 0
    fi

    ####################################################
    # Compute some other variables based on parameters #
    ####################################################
    local classFileName="${CLASSNAME}${EXTENSION}"
    if [ -n "$FILENAME_LOWER" ]; then
        classFileName=$(echo "$classFileName" | tr '[[:upper:]]' '[[:lower:]]')
    fi
    local classFilePath="${DIR}/${classFileName}"
    local extendsSnippet=""
    if [ -n "$EXTENDS" ]; then
        extendsSnippet=" extends ${EXTENDS}"
    fi
    local namespaceSnippet=
    local classFullName="${CLASSNAME}"
    if [ -n "$NAMESPACE" ]; then
        namespaceSnippet="namespace ${NAMESPACE};"
        classFullName="${NAMESPACE}\\${CLASSNAME}"
    fi

    #######################
    # Sanity check inputs #
    #######################
    if [ -z "$CLASSNAME" ]; then
        echo "ERROR: Class name not set" >&2
        return 1
    elif [ -z "$DIR" ]; then
        echo "ERROR: No directory specified" >&2
        return 1
    elif [ -z "$EXTENSION" ]; then
        echo "ERROR: Extension cannot be blank" >&2
        return 1
    elif [ ! -d "$(dirname "$classFilePath")" ]; then
        echo "ERROR: Class file directory does not exist '$(dirname "$classFilePath")'" >&2
        return 1
    elif [ -e "$classFilePath" ]; then
        echo "ERROR: Class file already exists at '${classFilePath}'" >&2
        return 1
    fi
    
    #########################
    # Compose the new class #
    #########################
    cat<<EOPHPF>"$classFilePath"
<?php

/**
 * This file contains the ${classFullName} class
 */
EOPHPF

    if [ -n "$namespaceSnippet" ]; then
        cat<<EOPHPF>>"$classFilePath"

${namespaceSnippet}
EOPHPF
    fi

    cat<<EOPHPF>>"$classFilePath"

/**
 * This class does something
 * @TODO Complete this documentation
 */
class ${CLASSNAME}${extendsSnippet}
{

}

EOPHPF
}

generatePHPClass $@

