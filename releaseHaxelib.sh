#!/bin/sh
set -e

echo Build and test...
bash build.sh

echo Submit...
haxelib run mlib submit
