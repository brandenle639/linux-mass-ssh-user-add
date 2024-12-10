#!/bin/bash
while IFS= read -r line || [[ -n "$line" ]]; do
    
    IN=$line
    set -- "$IN"
    IFS=":"; declare -a Array=($*)
	#Gets the user name
    iuser="${Array[0]}"
	#Gets the group list
	arr="${Array[1]}"
	#Gets the ssh key
	skey="${Array[2]}"
	#Sets the username to lowercase
    iuser=$(echo "$iuser" | tr '[:upper:]' '[:lower:]')
    #generates a random password (Doesn't tell you what it is)
    passwd=$(echo "$passwd" | md5sum | head -c 20)

	if [[ $iuser == "" ]]
	then
		echo "Username is missing on line: $line"
		exit
	fi
	if [[ $arr == "" ]]
	then
		echo "Groups is missing on line: $line"
		exit
	fi

	if [[ $skey == "" ]]
	then
		echo "ssh key is missing on line: $line"
		exit
	fi
    
    sudo useradd -m -p "$passwd" "$iuser"
	
    #Sets the new user's ssh dir path
	usersshdir=/home/$iuser/.ssh
	
	#Sets the new user's authrized_keys file path
	userauthkeysfile=/home/$iuser/.ssh/authorized_keys
	
    #Sets an existing ssh path for copy
	defaultsshdir=/home/ec2-user/.ssh
	
	#Copies the existing ssh folder to the user's ssh directory
	sudo cp -R "$defaultsshdir" "$usersshdir"
	
	#Appends the user's ssh key to their authorized_keys file
	sudo echo "$skey" >> $userauthkeysfile

	#Sets the proper permission for the user's ssh folder
    sudo chmod 700 "$usersshdir"

	#Sets the proper ownership of the user's ssh directory
	sudo chown -R $iuser:$iuser "$usersshdir"
	
	#Sets the proper permission for the user's authrized_keys file
	sudo chmod 600 "$userauthkeysfile"
	
	#Sets the proper ownership for the user's authrized_keys file
	sudo chown $iuser:$iuser "$userauthkeysfile"
	
	#Setss the group list
    set -- "$arr"
	#Splitss the group list
    IFS=","; declare -a grps=($*)
	#Loops through the group array
	for i in "${grps[@]}"
	do
		#Sets the user's group
		sudo usermod -aG $i $iuser
	done

done < sshkeys.txt
