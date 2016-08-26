#!/usr/bin/env bash

function test-expectations() {
    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: First commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"

    echo 'Expect reflog entry to exist'
    git reflog | grep -q ' commit: Undoing changes for master: First commit on '
    echo ' - ✓'

    echo 'Expect reflog entry contains undone changes'
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/single.1.diff)"
    echo ' - ✓'

    echo 'Expect that there are no changes'
    test -z "$(git status --short)"
    echo ' - ✓'
}

echo 1 >> TEST
git undo-index TEST &>/dev/null

test-expectations
