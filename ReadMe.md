This script will create a list of users, add them to the defined groups (If They Exists), and put the defined ssh keys into the related "authorized_keys" file

It is 1 ssh key per a user account line; but you can have the same user listed multiple times with different ssh keys.
    You will get a warning the related warning: "useradd: user '{user}' already exists", this is perfectly fine and the related ssh keys will add properly

To create a general user with no other related group(s) then just add an arbutrary group name and the system will give you a warning that the group doesn't exist but will still create user.

To Install and Run

    1. Create a text file named "sshkeys.txt" in the same folder as the "newusers.sh" script

    2. Enter the related information in the following format:
        username:groups:sshkey
            Example in "sshkeys-example.txt"

    3. Set "newusers.sh" as an executable
        sudo chmod +x newusers.sh

    4. Run the script as sudo
        sudo ./newusers.sh
