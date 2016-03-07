#!/bin/bash

branch_name=$1
 echo "branch create"
 git branch $branch_name >/dev/null
 if [ $? != 0 ]; then
   echo "Creating local branch failed."
   exit 0;
 fi
 git push origin $branch_name >/dev/null
 if [ $? != 0 ]; then
   echo "Creating remote branch failed."
   exit 0;
 fi
 git branch -d $branch_name >/dev/null
 if [ $? != 0 ]; then
   echo "Deleting local branch failed."
 fi

