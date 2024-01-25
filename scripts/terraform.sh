#!/bin/bash
set -e

# DEFAULTS
WORKING_DIR="$PWD"

# cli flags defaults
tfAction="plan"
tfDir="."
tfWorkspace=""
tfVarsFilePath=""

main() {
    terraform -chdir=$tfDir workspace new $tfWorkspace || true
    terraform -chdir=$tfDir workspace select $tfWorkspace
    terraform -chdir=$tfDir init -input=false --upgrade
    baseCommand="terraform -chdir=$tfDir $tfAction -input=false"
    if [[ "$tfAction" == "apply" || "$tfAction" == "destroy" ]]; then baseCommand="$baseCommand -auto-approve"; fi
    if [ "$tfAction" == "plan" ]; then baseCommand="$baseCommand -lock=false"; fi
    if [ "$tfVarsFilePath" != "" ]; then baseCommand="$baseCommand -var-file="$tfVarsFilePath""; fi
    $baseCommand

}

validations() {
    if [ "$tfWorkspace" == "" ]; then echo "Terraform workspace not specified" && exit 1; fi
}

parseArguments() {
    while [ $# -gt 0 ]; do
    case "$1" in
    --action=*)
        tfAction="${1#*=}"
        ;;
    --dir=*)
        tfDir="${1#*=}"
        ;;
    --workspace=*)
        tfWorkspace="${1#*=}"
        ;;
    --vars-file=*)
        tfVarsFilePath="${1#*=}"
        ;;
    --help)
        getUsageHelp
        exit 0
        ;;
    *)  
        echo $1
        echo "***************************\n"
        echo "Error: Invalid arguments\n"
        getUsageHelp
        echo "***************************\n"
        exit 1
    esac
    shift
    done
}

getUsageHelp() {
    echo "Usage: terraform.sh

    [--action=<(apply,plan,destroy)>]       # Terraform action to run. Defaults to 'plan'
    [--workspace=<id>]                      # the identifier from which to generate the workspaces names
    "
}

parseArguments $@
validations
main
