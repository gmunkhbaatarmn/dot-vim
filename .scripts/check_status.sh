#!/bin/bash

working_dir=`readlink --canonicalize $BASH_SOURCE`
working_dir=`dirname $working_dir`
working_dir=`dirname $working_dir`

for path in bundle/*; do
  cd $working_dir/$path
  if [[ `git status -s | grep -v 'doc/tags'` ]]; then
    echo $path
    git status -s
  fi
done

cd $working_dir
