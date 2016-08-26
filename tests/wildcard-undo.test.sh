#!/usr/bin/env bash

function test-expectations() {
    heading 'Wildcard undo with "*"'

    describe 'Expect reflog entry to exist'
    git reflog | grep -q ' commit: Undoing changes for master: First commit on '
    ok

    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: First commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"
    describe 'Expect reflog entry contains undone changes'
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/wildcard-undo.out)"
    ok

    describe 'Expect that there are no changes'
    test -z "$(git status --short)"
    ok
}

echo 1 >> TEST
git undo-index T* &>/dev/null

test-expectations
