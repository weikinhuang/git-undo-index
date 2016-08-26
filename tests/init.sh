#!/usr/bin/env bash

ln -s /data/git-undo-index /usr/bin/git-undo-index 2>/dev/null || true

# setup git author details
export GIT_AUTHOR_NAME="Test Runner"
export GIT_AUTHOR_EMAIL="foo@example.com"
export GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME";
export GIT_COMMITTER_EMAIL="$GIT_AUTHOR_EMAIL";

function run_test() {
    TEST_CASE="$1"
    TEST_DIR="$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 12 | head -n 1)"

    # initialize test git dir
    mkdir /tmp/${TEST_DIR}
    cd /tmp/${TEST_DIR}
    git init . &>/dev/null

    # prevent empty sha
    echo TEST > TEST
    git add TEST &>/dev/null
    git commit -m"First commit" &>/dev/null

    . "$TEST_CASE"

    # cleanup test dir
    cd /tmp
    rm -rf /tmp/${TEST_DIR}
}

# mock the date function for testing
function normalize-output() {
    sed -r  -e 's/[A-Za-z]{3} [A-Za-z]{3} [0-9]+ [0-9]{2}:[0-9]{2}:[0-9]{2} UTC [0-9]{4}/Fri Aug 26 00:00:00 UTC 2016/g' \
            -e 's/[A-Za-z]{3} [A-Za-z]{3} [0-9]+ [0-9]{2}:[0-9]{2}:[0-9]{2} [0-9]{4} \+0000/Fri Aug 26 00:00:00 2016 +0000/g' \
            -e 's/^commit [0-9a-zA-Z]{40}$/commit aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa/' \
            -e 's/index [0-9a-z]{7,}\.\.[0-9a-z]{7,} /index aaaaaaa..bbbbbbb /'
}

set -e
#set -x

for f in /data/tests/*; do
    case "$f" in
        *.test.sh)
            echo "================ running $f ================ "
            run_test "$f"
            echo
        ;;
    esac
done
