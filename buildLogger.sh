#!/bin/bash
haxelib run mlib allClasses

cd example/logger
bash build.sh
cd ../../