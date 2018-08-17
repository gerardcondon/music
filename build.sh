#!/bin/bash
 # options explanation at http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail

git submodule init
git submodule update

cd website
bundle
middleman build
middleman deploy