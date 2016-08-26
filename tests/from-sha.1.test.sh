#!/usr/bin/env bash

function test-expectations() {
    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: First commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"

    git reflog | cat -
    echo 'Expect reflog entry to exist'
    git reflog | grep -q -e ' commit: Undoing changes for [a-f0-9]\+: First commit on '
    echo ' - ✓'

    echo 'Expect reflog entry contains undone changes'
    git show ${REF_ENTRY} | normalize-output
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/from-sha.1.out)"
    echo ' - ✓'

    echo 'Expect that there are no changes'
    test -z "$(git status --short)"
    echo ' - ✓'
}

echo FILE2 > FILE2
git add FILE2 &>/dev/null
git commit -m"test commit" &>/dev/null
git checkout HEAD~

echo 1 >> TEST
git undo-index TEST &>/dev/null

test-expectations
