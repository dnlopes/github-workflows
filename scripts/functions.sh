#!/bin/bash
set -e

currentDir="$(dirname "$(readlink -f "${BASH_SOURCE}")")"
source ${currentDir}/pretty_print.sh

AUTOMATION_ROLE_NAME="IaCResourcesManager"

assumeRole() {
    if [ "$1" = "" ]; then printRed "usage: assumeRole <aws-account> <role-name>" && exit 1; fi
    if [ "$2" = "" ]; then printRed "usage: assumeRole <aws-account> <role-name>" && exit 1; fi

    printScreen "Assuming role $2 on account $1"
    roleSession=$(echo $RANDOM | md5 | head -c 10)
    export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
    $(aws sts assume-role --role-arn arn:aws:iam::$1:role/$2 --role-session-name $roleSession \
    --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" --no-cli-pager --output text))
    printGreen "Role assumed"
}

assumeAutomationRoleOnAccount() {
    if [ "$1" = "" ]; then printRed "usage: assumeAutomationRoleOnAccount <aws-account>" && exit 1; fi
    assumeRole "$1" "IaCResourcesManager"
}
