# git-undo-index
A `git checkout --` / `git reset --hard HEAD` replacement that stores changes in the reflog!

## Build status

[![Build Status](https://travis-ci.org/weikinhuang/git-undo-index.svg?branch=master)](https://travis-ci.org/weikinhuang/git-undo-index)

## Why

This script is a replacement for `git checkout --` and `git reset --hard HEAD`.

It undoes changes but keeps a reference to those changes in the `git reflog`. This provides a
non-destructive way to revert local changes.

This script also attempts to preserve any staged changes just like `git checkout --`.

Anyone that's ever done either `git checkout -- FILE` or `git reset --hard HEAD` without first stashing or
committing realizes that there is no way to recover those changes, this script tries to solve that problem.

## Installing

```bash
sudo curl -sSL -o /usr/local/bin/git-undo-index https://raw.githubusercontent.com/weikinhuang/git-undo-index/master/git-undo-index
chmod +x /usr/local/bin/git-undo-index
```

## Usage

```bash
git undo-index [<pathspec>...]
```

## Alias

In `.gitconfig`

```
[alias]
    undo = undo-index
````

## Example

```bash
echo TEST > TEST
echo DELFILE > DELFILE
git add DELFILE TEST
git commit -m"test commit"

echo FILE2 > FILE2
git add FILE2

echo 1 >> TEST
rm -f DELFILE
git undo-index .
```

---

The resulting `git status`
```bash
On branch master
Changes to be committed:
  (use "git reset HEAD <file>..." to unstage)

        new file:   FILE2

```

---

The `git reflog`
```bash
8b6584a HEAD@{0}: checkout: moving from __undo_20034_1472180962 to master
af417b7 HEAD@{1}: commit: Undoing changes for master: test commit on Fri Aug 26 03:09:22 UTC 2016
```

---

The reflog entry for `git show HEAD@{1}`
```diff
commit af417b7a8ab0b46ec5af0cf9d7aeb0472abcf455
Author: Test Runner <foo@example.com>
Date:   Fri Aug 26 03:09:22 2016 +0000

    Undoing changes for master: test commit on Fri Aug 26 03:09:22 UTC 2016

diff --git a/DELFILE b/DELFILE
deleted file mode 100644
index 9513480..0000000
--- a/DELFILE
+++ /dev/null
@@ -1 +0,0 @@
-DELFILE
diff --git a/TEST b/TEST
index 2a02d41..0f7c719 100644
--- a/TEST
+++ b/TEST
@@ -1 +1,2 @@
 TEST
+1
```

## Developing

TODO
