#!/usr/bin/env bash

function test-expectations() {
    heading 'Undo changes when checked out from detached head state'

    describe 'Expect reflog entry to exist'
    git reflog | grep -q -e ' commit: Undoing changes for [a-f0-9]\+: First commit on '
    ok

    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: First commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"
    describe 'Expect reflog entry contains undone changes'
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/from-sha.out)"
    ok

    describe 'Expect that there are no changes'
    test -z "$(git status --short)"
    ok
}

echo FILE2 > FILE2
git add FILE2 &>/dev/null
git commit -m"test commit" &>/dev/null
git checkout HEAD~ &>/dev/null

echo 1 >> TEST
git undo-index TEST &>/dev/null

test-expectations
