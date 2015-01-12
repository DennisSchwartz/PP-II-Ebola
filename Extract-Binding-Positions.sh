#!/bin/bash

awk '$3 > 20 { print $1 }' $1 > temp_file;

grep -E '^\d' temp_file > ${2}-Binding-Sites.txt;

rm temp_file;