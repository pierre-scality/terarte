sed 's/\ //g' |sed 's/\"//g'|sed 's/\,//'| awk -v i=1 '{printf "%s\ts%s\n",$1,i ; i+=1 }
