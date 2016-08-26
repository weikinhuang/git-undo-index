#!/usr/bin/env bash

function test-expectations() {
    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: test commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"

    describe 'Expect reflog entry to exist'
    git reflog | grep -q ' commit: Undoing changes for master: test commit on '
    ok

    describe 'Expect reflog entry contains undone changes'
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/single-undo-staged-deletion.out)"
    ok

    describe 'Expect that there are no changes'
    test "$(git status --short)" == "$(cat /data/tests/expects/single-undo-staged-deletion.status)"
    ok
}

echo DELFILE > DELFILE
git add DELFILE &>/dev/null
git commit -m"test commit" &>/dev/null

rm -f DELFILE
git add DELFILE &>/dev/null

echo 1 >> TEST
git undo-index TEST &>/dev/null

test-expectations
