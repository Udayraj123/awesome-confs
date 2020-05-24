#!/bin/sh
# Some colors # Sequence of text colors : black (0), red, green, yellow, blue, magenta, cyan,white
# https://ss64.com/bash/syntax-prompt.html
_black=$(tput setaf 0);	_red=$(tput setaf 1);
_green=$(tput setaf 2);	_yellow=$(tput setaf 3);
_blue=$(tput setaf 4);	_magenta=$(tput setaf 5);
_cyan=$(tput setaf 6);	_white=$(tput setaf 7);
_reset=$(tput sgr0);

# Args and Globals handling
if ! [ -x "$(command -v hub)" ]; then
  echo '{_red}Error: hub is not installed. Run {_yellow}`brew install hub`{_reset}' >&2
  exit 1
fi

if [[ ! -n "$1" ]];then
    echo "{_yellow}Usage: git pr <[owner:]branch> [<message>]{_reset}"
    exit 1
fi

if [[ -n "$2" ]];then
    MESSAGE="$2"
fi


# Functions/Utils
getOwnerFromUrl(){
    echo $1 | awk -F'github.com' '{print $2}' | cut -d/ -f 2
}

selectOwner(){
    local OWNER_OPTIONS=""
    local SELECT_LABELS=()
    for remote in $(git remote | sort); do 
        local URL=$(git remote get-url "${remote}")
        local owner=$(getOwnerFromUrl $URL)
        OWNER_OPTIONS+=":$owner"
        SELECT_LABELS+=("$owner:$BRANCH")
    done
    title="${_cyan}Where do you want to create the PR?${_yellow}"
    prompt="${_cyan}Pick an option:${_reset}"

    echo "$title"
    PS3="$prompt "
    select opt in ${SELECT_LABELS[@]}; do 
        SELECTED_OWNER=$(echo $OWNER_OPTIONS | cut -d: -f $((REPLY+1)))
        OPT_LENGTH=$(( ${#SELECT_LABELS[@]}+1 ));
        if [ 1 -le "$REPLY" ] && [ "$REPLY" -le $OPT_LENGTH ];then
            case "$REPLY" in
            OPT_LENGTH ) echo "Goodbye!"; exit 1;;
            *) break;; #echo "Picked: $SELECTED_OWNER"; break;;
            esac;
        else
            echo "Wrong selection: Select any number from 1-$OPT_LENGTH"
        fi 
    done
}

getBranchRef(){
    local OWNER=$(echo $1 |  awk '{split($0,a,":"); print a[1]}')
    local BRANCH=$(echo $1 | awk '{split($0,a,":"); print a[2]}')
    # support default owner
    if [[ ! -n "$BRANCH" ]];then
        BRANCH="$OWNER"
        selectOwner
        OWNER="$SELECTED_OWNER" 
    fi
    BRANCH_REF="$OWNER:$BRANCH"
}

getPRTitle(){
    local currentBranch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD);
    local branchType=$(echo $currentBranch | cut -f1 -d/)
    local issueID=$(echo $currentBranch | cut -f 2- -d/)
    TITLE_PREFIX="[$branchType][$issueID]"
    MESSAGE=$(git log --oneline -n 1 | sed 's/[^ ]* //')
    PR_TITLE="$TITLE_PREFIX $MESSAGE"
}

# Main Body
getBranchRef $1
getPRTitle
echo "\t${_blue}Ref: ${_yellow}$BRANCH_REF${_reset}"
echo "\t${_blue}Title: ${_yellow}$PR_TITLE${_reset}"
read -e -p "${_cyan}Custom Title?${_blue}(press enter to use above): ${_reset}" MESSAGE
# for Bash v4: # read -e -p "\tPR Title: " -i "$PR_TITLE" PR_TITLE

if [[ ! $MESSAGE =~ ^[\s]*$ ]]; then
    PR_TITLE="$TITLE_PREFIX $MESSAGE"
fi
# echo "Making PR with Title: $PR_TITLE"
echo "${_green}$> ${_blue}hub pull-request -o -b "$BRANCH_REF"  -m '${PR_TITLE}'${_reset}"
read -e -p "${_cyan}Press enter to run: ${_reset}" REPLY
if [[ $REPLY =~ ^[\s]*$ ]]; then
    hub pull-request -o -b "$BRANCH_REF"  -m "$PR_TITLE";
fi