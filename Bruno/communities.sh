#!/bin/bash          

SET=$(cat $1 | grep -v "^#")

for file in $SET;
do
	echo "File: $file" >> $2
	cat ../Benchmarks/$file | ../Haskell/Graph variable | ../Snap/examples/community/community -i:/dev/stdin -o:/dev/stdout | grep "^#" >> $2
done
