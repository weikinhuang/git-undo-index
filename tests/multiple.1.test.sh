#!/usr/bin/env bash

function test-expectations() {
    local REF_ENTRY="$(git reflog | grep ' commit: Undoing changes for master: test commit on ' | head -n1 | cut -f2 -d' ' | tr -d ':')"

    echo 'Expect reflog entry to exist'
    git reflog | grep -q ' commit: Undoing changes for master: test commit on '
    echo ' - ✓'

    echo 'Expect reflog entry contains undone changes'
    test "$(git show ${REF_ENTRY} | normalize-output)" == "$(cat /data/tests/expects/multiple.1.out)"
    echo ' - ✓'

    echo 'Expect that there are no changes'
    test -z "$(git status --short)"
    echo ' - ✓'
}

echo FILE2 > FILE2
git add FILE2 &>/dev/null
git commit -m"test commit" &>/dev/null

echo 1 >> TEST
echo 2 >> FILE2
git undo-index . &>/dev/null

test-expectations