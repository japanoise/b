#!/bin/bash
instdir="$HOME"/dos/b/
mkdir -pv "$instdir"
for f in *.asm
do
    fn=$(basename "$f" .asm)
    fasm "$f" "$fn".com
    cp -v "$fn".com "$instdir"
done
