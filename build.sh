set -e

#!/bin/bash

mkdir -p build

echo compile CLI
cd cli
haxe build.hxml
cd ../

echo compile all classes
haxelib run mlib allClasses
haxe buildAllClasses.hxml

echo run examples
cd example
bash build.sh
cd ../

echo run tests neko
haxelib run munit test -neko -coverage

haxelib run mlib install