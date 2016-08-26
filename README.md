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

TODO

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
