#!/bin/bash
set -e

# pretify the output for local dev. (Unset if running on pipeline)
# if you want to play with the colors: https://linuxopsys.com/topics/customizing-bash-prompt-in-linux-changing-colors
RESET_COLOR="\e[0m"
RED_COLOR="\e[31m"
YELLOW_COLOR="\e[33m"
BLUE_COLOR="\e[36m" # cyan. Blue is hard to read on darkmode
GREEN_COLOR="\e[32m"
BOLD_OUTPUT="\e[1m"

# unset the colors if running on pipeline to not messup with output
unsetColorsIfRunningOnPipeline() { # param = pipelineRun value
    if [ "$1" == "true" ]; then
        unset RESET_COLOR
        unset RED_COLOR
        unset YELLOW_COLOR
        unset BLUE_COLOR
        unset GREEN_COLOR
        unset BOLD_OUTPUT
    fi
}

### print methods ###
printScreen() {
    local indentation="$2"
    printf "%${indentation}s$1\n"
}

printRed() {
    printScreen "${RED_COLOR}✗ $1${RESET_COLOR}" "$2"
}

printYellow() {
    printScreen "${YELLOW_COLOR}! $1${RESET_COLOR}" "$2"
}

printBlue() {
    printScreen "${BLUE_COLOR}► $1${RESET_COLOR}" "$2"
}

printGreen() {
    printScreen "${GREEN_COLOR}✔ $1${RESET_COLOR}" "$2"
}
