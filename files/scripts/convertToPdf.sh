#!/usr/bin/env bash

fileToPdfConversionFunc() {
    arg=$1
    filename=$(echo "${arg}" | sed 's/\.[^.]*$//' | sed 's/\.[^\\]*$//' | sed 's#^.*/##')
    if [[ $arg == "" ]] || [[ -z $arg ]]; then
        echo -e "Usage: convertToPdf ./File.txt"
        return 1
    elif [[ ! -f "$arg" ]]; then
        echo "Error: File does not Exist."
        return 1
    else
        soffice --convert-to pdf "$arg" &>/dev/null > /dev/null 2>/dev/null && echo "Successfully Converted File.\nProduced PDF at '${PWD}/${filename}.pdf'." || echo "Error: Could not Convert File to PDF."
        return 0
    fi
}

alias toPdf="fileToPdfConversionFunc $@"
alias convertToPdf="fileToPdfConversionFunc $@"
