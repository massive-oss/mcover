set -e

mkdir -p build
mkdir -p build/bin

#!/bin/bash

mkdir -p build

echo compile CLI
cd cli
haxe build.hxml
cd ../

echo compile all classes
haxelib run mlib allClasses
haxe buildAllClasses.hxml

day=$( date +%s )
fname="src/stamp.txt"

echo  $( date -r ${day} ) | md5 >${fname}

haxelib run mlib install

echo run examples
cd example
bash build.sh
cd ../

echo run tests neko
haxelib run munit test -neko -coverage
