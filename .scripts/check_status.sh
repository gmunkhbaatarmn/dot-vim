#!/bin/bash

rm --force patches/*.patch

working_dir=`readlink --canonicalize $BASH_SOURCE`
working_dir=`dirname $working_dir`
working_dir=`dirname $working_dir`

for path in plugged/*; do
  cd $working_dir/$path
  if [[ `git status -s | grep -v 'doc/tags'` ]]; then
    echo $path
    git add --all
    git status --short
    name=`basename -a $path`
    git diff --cached > "../../patches/$name.patch"
  fi
done

cd $working_dir
