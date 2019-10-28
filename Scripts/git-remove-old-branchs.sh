#!/bin/bash
LIMIT_DAYS=180

NOW=`date +'%Y-%m-%d'`
echo "- Date Now       : ${NOW}"
NOW180=`date -d "${now} -${LIMIT_DAYS} days" +'%Y-%m-%d'`
echo "- Date Filter (Now-180): ${NOW180}"

# Create header of list branch to remove
echo "BRANCH NAME;BRANCH CLEAN;LAST UPDATE" > list_branch_removed.csv

function removeOlderBranch() {

  if [ -n "$1" ]; then
  
  # List branch already merged
  for branch in `git branch -r --merged | grep -v "HEAD" | grep -v "develop" | grep -v "master" | grep -v "manut" | grep -v "release" $1`
  do
    # get date of last commit in branch
    BRANCH_HEAD=`git show --format="%ci" ${branch} | cut -d' ' -f1 | head -n 1`

    # convert date to compare
    DATE_BRANCH=`date -d "${BRANCH_HEAD}" +%s`
    DATE_NOW=`date -d "${NOW} -${LIMIT_DAYS} days" +%s`

    if [ "${DATE_BRANCH}" -le "${DATE_NOW}" ]; then
      echo "${branch};`getCleanBranchName ${branch}`;${BRANCH_HEAD}" >> list_branch_removed.csv
    fi
  done
}

function getCleanBranchName() {
  branch=`echo $1 | sed 's/origin\///g'`
  echo "$branch"
}
# Remove all
removeOlderBranch '| grep -v "hotfix"'

# Remove HOTFIX branchs is not containt "-EP"
removeOlderBranch '| grep "hotfix" | grep -vi "\-EP"';
