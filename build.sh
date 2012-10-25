#!/bin/bash

set -e

echo '  create missing build directories'
mkdir -p bin
mkdir -p bin/output
mkdir -p bin/coverage

echo '  compile CLI'
cd cli
haxe build.hxml
cd ../

echo '  compile all classes'
haxelib run mlib allClasses
haxe buildAllClasses.hxml


echo '  create md5 hash stamp'
day=$( date +%s )
fname="src/stamp.txt"

echo  $( date -r ${day} ) | md5 >${fname}

haxelib run mlib install

echo '  run examples'
# cd example
# bash build.sh
# cd ../
cd example/coverage/01_BasicCoverage
haxe build-neko.hxml
haxelib run mcover r bin/report -neko
cd ../../../

# echo '  run tests neko'
# haxelib run munit test -neko -coverage
