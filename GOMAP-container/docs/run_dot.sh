

#!/bin/bash
#dot -Tsvg  -o intro.svg intro.dot
#dot -Tsvg  -o goal1.svg goal1.dot
#dot -Tsvg  -o goal2.svg goal2.dot

file=$1
outfile=${file%%.dot}
i=0
while true
do
	ATIME=`stat -c %Z $file`
	if [[ "$ATIME" != "$LTIME" ]]
	then
		i=`expr $i + 1`
		echo "Updated $i"
		`dot  -Tsvg  -o $outfile.svg $file`

		LTIME=$ATIME
	fi
	sleep 4
done

#-Gsize=10,15
