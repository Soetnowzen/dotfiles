#!/bin/bash

set -e

if [ $# -ne 1 ]; then
    echo "ERROR: no commit to revert specified" 1>&2
    exit 1
fi

getCurrentHead() {
    git rev-parse HEAD
}

declare -a commitsToRevert
commitToRevert="$1"
startCommit="$(getCurrentHead)"
commitsInDiff="$(git log --format=%H ${commitToRevert}..${startCommit} | tac)"

git reset --hard "${commitToRevert}^" > /dev/null
currentHead=$(getCurrentHead)

for commit in ${commitsInDiff}; do
    if git cherry-pick ${commit} &> /dev/null; then
        currentHead=$(getCurrentHead)
    else
        commitsToRevert=("${commit}" "${commitsToRevert[@]}")
        git reset --hard ${currentHead} > /dev/null
    fi
done

git reset --hard "${startCommit}" > /dev/null
for commit in "${commitsToRevert[@]}"; do
    echo "### Reverting ${commit}"
    git revert "${commit}" --no-edit &> /dev/null
done

echo "### Reverting original commit to revert, ${commitToRevert}"
git revert "${commitToRevert}" --no-edit > /dev/null

echo ""
echo "All done, conclude the revert by creating a squash commit, e.g. with:"
echo "  git rebase -i ${startCommit}"

