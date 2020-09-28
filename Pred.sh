#!/bin/bash

for str in `grep -Eo '(0 @.*@ INDI|1 NAME .* /.*/)' $1 | sed 's/0 @/@/g; s/@ INDI/@/g; s/1 NAME //g; s/\///g; s/ /_/g;'`; do
	echo $str >> text
done

for str in `grep -Eo '(0 @.*@ FAM|1 HUSB @.*@|1 WIFE @.*@|1 CHIL @.*@)' $1 | sed 's/0 @.*@ FAM/FAM/g; s/1 HUSB/HUSB/g; s/1 WIFE/WIFE/g; s/1 CHIL/CHIL/g; '`; do
	echo $str >> text2
done

h=0
w=0
c=0
h2=0
w2=0
c2=0

for str in `cat text2`; do

		if [ $h -eq 1 ]
			then
				hid=$str				
				h=0
		fi


		if [ $w -eq 1 ]
			then
				wid=$str				
				w=0
		fi

		if [ $c -eq 1 ]
			then
				cid=$str				
				for str2 in `cat text`; do

					if [ $h2 -eq 1 ]
					then
							hname=$str2							
							h2=0		
					fi

					if [ $w2 -eq 1 ]
					then
							wname=$str2							
							w2=0
						
					fi

					if [ $c2 -eq 1 ]
					then
							cname=$str2
							
							c2=0
							echo "father('"$hname"','"$cname"')." >> predicats1.pl
							echo "mother('"$wname"','"$cname"')." >> predicats1.pl
					fi


					if [ $hid = $str2 ]
					then
						h2=1
					fi

					if [ $wid = $str2 ]
					then
						w2=1
					fi

					if [ $cid = $str2 ]
					then
						c2=1
					fi
				done
				c=0
		fi



		if [ $str = HUSB ]
		then
			h=1
		fi

		if [ $str = WIFE ]
		then
			w=1
		fi

		if [ $str = CHIL ]
		then
			c=1
		fi	
done
sort predicats1.pl > predicats.pl
rm predicats1.pl
rm text*

