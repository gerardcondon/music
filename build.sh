#!/bin/bash
 # options explanation at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
set -x

git config --global user.name "$USER_NAME"
git config --global user.email "$USER_EMAIL"

git submodule init
git submodule update

cd website
bundle
middleman build
middleman deploy