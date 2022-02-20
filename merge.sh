#!/bin/bash
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git show-ref
git remote update
git fetch --all
git checkout pipeline
git pull
CURRENT_VERSION=`npm pkg get version`
echo "Current Version is set to $CURRENT_VERSION. Please input the new version"
read VERSION
echo "Please input the remote name of the pipeline repository"
read PIPE_REPO
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git show-ref
git remote update
git fetch --all
# upgrade versions in package.json
npm pkg set version="$VERSION"
npm i --package-lock-only
git add package.json
git add package-lock.json
git commit -m "upgrading to $VERSION"
git push
git checkout main
git pull
git merge --no-ff --no-edit pipeline
LASTSTATUS=$?
echo "last status of git merge was $LASTSTATUS"
if [ $LASTSTATUS -ne 0 ]; then
    echo "The merge failed."
    exit 1  
fi
git push

git push $PIPE_REPO
