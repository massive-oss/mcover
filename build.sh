#!/bin/bash
haxelib run mlib allClasses
haxe buildAllClasses.hxml


cd example
bash build.sh
cd ../
haxelib run munit test -neko -coverage
haxelib run mlib install