#!/usr/bin/env bash

function test-expectations() {
    heading 'Undo changes only found in the index when the file is also staged with other changes'

    describe 'Expect reflog entry to exist'
    git reflog | grep -q ' commit: Undoing changes for master: First commit on '
    ok

    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: First commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"
    describe 'Expect reflog entry contains undone changes'
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/staged-and-changes.out)"
    ok

    describe 'Expect that there are still changes'
    test "$(git status --short)" == "$(cat /data/tests/expects/staged-and-changes.status)"
    ok
}

echo 1 > TEST
git add TEST &>/dev/null
echo 2 > TEST
git undo-index TEST &>/dev/null

test-expectations
