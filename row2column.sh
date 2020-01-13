mcloutput=$1

nl -w1 -s " " $mcloutput| awk '{print "commun="$0}'|sed 's/\t/\n/g; s/ /\n/g'|\
awk '{if($0~/.*commun/){split($0,a,"=");print a[1]}else{print $0"\t"a[2]}}' | sed '/^commun/d' |sed '/^\t/d' > $mcloutput-2col_info
