#!/bin/sh

echo Deleting all bad links in `pwd`
find -L . -type l -exec rm \{\} \;
