#!/bin/bash

set -o posix

expectError() {
    showLoadingBar "    Testing that an error occurs running: ${HIGHLIGHTCOLOR}${1}" 'dontClear'
    error="$( ${1} 2>&1 1>/dev/null)"
    if [ $? -eq 0 ]; then
        notifyUser "    ${3}${CLEAR_ALL_TEXT_STYLES}" 0 'dontClear'
        ((FAILS++))
    else
        notifyUser "    ${2}${CLEAR_ALL_TEXT_STYLES}" 0 'dontClear'
        notifyUser "    ${ERRORCOLOR}${error}" 0 'dontClear'
        ((PASSES++))
    fi
}

expectSuccess() {
    showLoadingBar "    Testing that an error does not occur running: ${HIGHLIGHTCOLOR}${1}" 'dontClear'
    error="$( ${1} 2>&1 1>/dev/null)"
    if [ $? -eq 0 ]; then
        notifyUser "    ${2}${CLEAR_ALL_TEXT_STYLES}" 0 'dontClear'
        ((PASSES++))
    else
        notifyUser "    ${3}${CLEAR_ALL_TEXT_STYLES}" 0 'dontClear'
        notifyUser "    ${ERRORCOLOR}${error}" 0 'dontClear'
        ((FAILS++))
    fi
}

assertSuccess() {
    expectSuccess "${1}" "${SUCCESSCOLOR}${RED_FG_COLOR}As expected, no errors occured running ${HIGHLIGHTCOLOR}${1}" "${ERRORCOLOR}An error occurred running ${HIGHLIGHTCOLOR}${1}"
}

assertError() {
    expectError "${1}" "${SUCCESSCOLOR}${RED_FG_COLOR}As expected, an error occured running ${HIGHLIGHTCOLOR}${1}" "${ERRORCOLOR}An error was expected, no errors occurred running ${HIGHLIGHTCOLOR}${1}"
}

assertDirectoryExists() {
    [[ ! -d "${1}" ]] && notifyUser "    ${ERRORCOLOR}Failed asserting that the directory ${HIGHLIGHTCOLOR}${1}${NOTIFYCOLOR} exists" 0 'dontClear' && ((FAILS++)) && return
    notifyUser "    As expected, the ${HIGHLIGHTCOLOR}${1}${NOTIFYCOLOR} directory exists ${SUCCESSCOLOR}:)" 0 'dontClear' && ((PASSES++))
}

assertDirectoryDoesNotExist() {
    [[ -d "${1}" ]] && notifyUser "    ${ERRORCOLOR}Failed asserting that the directory ${HIGHLIGHTCOLOR}${1}${NOTIFYCOLOR} does not exist" 0 'dontClear' && ((FAILS++)) && return
    notifyUser "    As expected, the ${HIGHLIGHTCOLOR}${1}${NOTIFYCOLOR} directory does not exist ${SUCCESSCOLOR}:)" 0 'dontClear' && ((PASSES++))
}
