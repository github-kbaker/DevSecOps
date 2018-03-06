#!/usr/bin/env bash
# untitled.sh at https://github.com/wilsonmar/DevSecOps/HTM/???
# Described on tutorial page https://wilsonmar.github.io/anomaly-analysis
# PROTIP: No errors in scan at https://www.shellcheck.net/ from https://github.com/koalaman/shellcheck

# This bash script runs on Mac OSX to install Numata's assets to ...

# To run this, open a Terminal window and manually:
#   chmod +x htm-init.sh
#   ./htm-init.sh

# Display commands to the console for better troubleshooting during script development:
#set -v

echo "**** Fail out if if any step in a pipeline fails."
set -o pipefail

# echo "**** Start elasped timer:"
TIME_START="$(date -u +%s)"

# Read first parameter from command line supplied at runtime to invoke:
MY_RUNTYPE=$1
#MY_RUNTYPE="ALL"
echo "**** MY_RUNTYPE=$MY_RUNTYPE"


GITHUB_ACCT="wilsonmar"   # change for yourself.
MY_REPO="HTM"
MY_FOLDER="install"

if [ -d "$MY_REPO" ]; then
    echo "**** MY_REPO \"$MY_REPO\" exists. Deleting to make way ..."
    rm -rf ${MY_REPO}
    #ls
else
    echo "**** MY_REPO \"$MY_REPO\" does not exist. Creating..."
fi

exit


# PROTIP: Execute follow-on CD command only if previous step was successful:
git clone https://github.com/${GITHUB_ACCT}/${MY_REPO}.git && cd ${MY_REPO}
        # Cloning into 'orchestrate-with-kubernetes'...
        # remote: Counting objects: 90, done.
        # remote: Total 90 (delta 0), reused 0 (delta 0), pack-reused 90
        # Unpacking objects: 100% (90/90), done.


echo "**** Use $MY_FOLDER folder"
cd ${MY_FOLDER}
echo "**** Present directory contents:"
ls
    # cleanup.sh deployments  nginx  pods  services  tls

# https://numenta.com/applications/htm-studio/



echo "**** Repository \"$MY_REPO\" not removed for troubleshooting after run."

TIME_END=$(date -u +%s);
DIFF=$((TIME_END-TIME_START))
echo "**** End of script after $((DIFF/60))m $((DIFF%60))s seconds elasped."
