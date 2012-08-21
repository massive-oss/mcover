#!/bin/bash
set -e

haxelib run mlib allClasses

cd example/coverage
bash build.sh
cd ../../