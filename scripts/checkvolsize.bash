cat config.yaml | grep Gi | sort | uniq| grep -w size| sed s/Gi//|  awk  -F ':' '{printf "%s +",$2}  ; END {print "0" }' | bc
