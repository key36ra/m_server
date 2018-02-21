# 14/15: Interpreter
#!/bin/bash

function func_script(){
	# 07: Function
	echo Hello;
	
	# 05: Command return
	var=$((1+2)) # $(cmd) = cmd return
	echo $var
	
	# 08: Show variable and function
	#set # show all
	#declare -f # only function
	
	# 10: Alias
	shopt -s expand_aliases
	source ~/.bashrc
	alias lsl='ls -l'
	lsl
	
	# 12: Special shell variable
	echo $$ # $$ = PID
	
	# 16: Permission
	chmod 755 * # "r-w" need to execute the script
	
	# 17: Read arguments
	echo $0 $1 $2 # "a b c" ==> $0=a, $1=b, $2=c
	
	# 19: If
	if [ -f ~/.bashrc ]; then # [-d] == test -d
		echo '~/.bachrc exists!'
	fi
	
	# 20: Elif
	# argument = file name
	if test -d $1;then # -d ==> file exist && file is directory
		echo "$1 is directory";
	elif test -f $1;then # -f ==> file exist && file is normal
		echo "$1 is file";
	elif test -e $1;then # -e ==> file exist
		echo "$1 is true"
	fi
	
	# 23: Read input
	echo "Please input any strings:"
	read musium
	echo "Your input is '$musium'"
	
	# 24: Iterative processing
	seq 2
	n=0
	for i in `seq 10`;
	do
		let "n=n+i"
	done
	echo "Calculated total value ~10 is '$n'"
	
	# 25: End value
	echo $? # if ?==0{ last cmd = success end value }
}
	
function func_sql(){
	DB='m_lpic'
	TAB='m_tab'
	OPTIONS='-u root -p'
	pass='kimkim'
	
	sql_show="
	use $DB
	select * from $TAB;
	"
	
	# 26: Select all record
	sql_26="
	use $DB
	select * from $TAB;
	"
	
	# 27: Select specific record
	sql_27="
	use $DB
	select exam_id, exam_name from $TAB;
	"
	
	# 28: Count record
	sql_28="
	use $DB
	select count(*) from $TAB;
	"
	
	# 30: Conditional expression
	sql_30="
	use $DB
	select exam_name from $TAB where level='level1';
	"
	
	# 31: Aggregate function
	sql_31="
	select level, sum(exam_fee) from $TAB group by level;
	"
	
	# 32: Insert
	sql_32="
	use $DB
	insert into $TAB values('4', 'level3', 'lpi301', '30000');
	"
	
	echo "$sql_show$sql_31" | mysql $OPTIONS$pass
}


func_script
func_sql
