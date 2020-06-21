#!/usr/bin/env bash

STR=$1

function epochConv() {
    echo "EpochTime:  ${1}"
    echo "EpochMills: ${1}000"
    echo "FormatJST:  `date -r ${1} +"%Y-%m-%dT%H:%M:%S"`+09:00"
    echo "FormatUTC:  `date -u -r ${1} +"%Y-%m-%dT%H:%M:%S"`Z"
}

function epochConvmills() {
    echo "EpochTime:  ${1:0:10}"
    echo "EpochMills: ${1}"
    echo "FormatJST:  `date -r ${1:0:10} +"%Y-%m-%dT%H:%M:%S"`+09:00"
    echo "FormatUTC:  `date -u -r ${1:0:10} +"%Y-%m-%dT%H:%M:%S"`Z"
}

function formatJST() {
    epoch=`date -j -f "%Y-%m-%dT%H:%M:%S" ${1} +%s`
    echo "EpochTime:  ${epoch}"
    echo "EpochMills: ${epoch}000"
    echo "FormatJST:  ${1}+09:00"
    echo "FormatUTC:  `date -u -r ${epoch} +"%Y-%m-%dT%H:%M:%S"`Z"
}

function formatUTC() {
    epoch=`date -u -j -f "%Y-%m-%dT%H:%M:%S" ${1} +%s`
    echo "EpochTime:  ${epoch}"
    echo "EpochMills: ${epoch}000"
    echo "FormatJST:  `date -r ${epoch} +"%Y-%m-%dT%H:%M:%S"`+09:00"
    echo "FormatUTC:  `date -u -r ${epoch} +"%Y-%m-%dT%H:%M:%S"`Z"
}

function help() {
    echo "____        _          ____                          _"
    echo "|  _ \  __ _| |_ ___   / ___|___  _ ____   _____ _ __| |_"
    echo "| | | |/ _\` | __/ _ \ | |   / _ \| '_ \ \ / / _ \ '__| __|"
    echo "| |_| | (_| | ||  __/ | |__| (_) | | | \ V /  __/ |  | |_"
    echo "|____/ \__,_|\__\___|  \____\___/|_| |_|\_/ \___|_|   \__|"
    echo "~Convert EpochTime or EpochMills or FormatTime to other format~"
    echo ""
    echo ""
    echo "Usage: "
    echo "      dateconvert {epoch | epochmills | %Y-%m-%dT%H:%M:%S} (UTC)"
    echo ""
    echo "      ex) $ dateconvert 1234567890"
    echo "              EpochTime:  1234567890"
    echo "              EpochMills: 1234567890000"
    echo "              FormatJST:  2009-02-14T08:31:30+09:00"
    echo "              FormatUTC:  2009-02-13T23:31:30Z"
}

if [[ $STR =~ ^[0-9]{10}$ ]]; then
    epochConv $STR
fi

if [[ $STR =~ ^[0-9]{13}$ ]]; then
    epochConvmills $STR
fi

if [[ $STR =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}$ ]]; then
    if [ "${2}" = "UTC" ]; then
        formatUTC $STR
    else
        formatJST $STR
    fi
fi

if [ "${1}" = "" ] || [ "${1}" = "help" ]; then
    help
fi
