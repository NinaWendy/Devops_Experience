#Backup
#!/bin/bash

for user in $(ls /home); do
    AUTH_KEYS="/home/$user/.ssh/authorized_keys"
    BACKUP="/home/$user/.ssh/authorized_keys.bak"

    # Ensure .ssh directory exists
    if [[ -f "$AUTH_KEYS" ]]; then
        cp "$AUTH_KEYS" "$BACKUP"
        echo "Backup created for $user"
    fi
done

#For a single user

#!/bin/bash
# Define the user for the demo
user="username"

AUTH_KEYS="/home/$user/.ssh/authorized_keys"
BACKUP="/home/$user/.ssh/authorized_keys.bak"

# Ensure authorized_keys file exists
if [[ -f "$AUTH_KEYS" ]]; then
    # Create a backup
    cp "$AUTH_KEYS" "$BACKUP"
    echo "Backup created for $user at $BACKUP"
else
    echo "No authorized_keys file found for $user!"
fi

#SSH into the jumpbox with agent forwarding
ssh -A user@jumpbox-ip

#Detect Changes Using diff
#Find and Replace Keys on Remote Servers

#!/bin/bash

user="username"
remote_user="username"
remote_servers=("192.168.x.x")
AUTH_KEYS="/home/$user/.ssh/authorized_keys"
BACKUP="/home/$user/.ssh/authorized_keys.bak"

if [[ -f "$AUTH_KEYS" && -f "$BACKUP" ]]; then
    sort "$BACKUP" -o "$BACKUP"
    sort "$AUTH_KEYS" -o "$AUTH_KEYS"

    CHANGES=$(diff "$BACKUP" "$AUTH_KEYS")

    if [[ -n "$CHANGES" ]]; then
        echo "SSH key changes detected for $user"

        OLD_KEY=$(comm -23 "$BACKUP" "$AUTH_KEYS")
        NEW_KEY=$(comm -13 "$BACKUP" "$AUTH_KEYS")

        if [[ -n "$OLD_KEY" && -n "$NEW_KEY" ]]; then
            for server in "${remote_servers[@]}"; do
                echo "Updating key for $user on $server"

                ssh "$remote_user@$server" <<EOF
                    sed -i 's|$OLD_KEY|$NEW_KEY|' /home/$remote_user/.ssh/authorized_keys
                    echo "Updated key for $user on $server"
EOF
                if [[ $? -eq 0 ]]; then
                    echo "Key update successful, updating backup file..."
                    cp "$AUTH_KEYS" "$BACKUP"
                    echo "Backup updated for $user"
                else
                    echo "Error: SSH authentication failed or key update failed. Backup not updated."
                fi
            done
        fi
    else
        echo "No changes detected in authorized_keys for $user."
    fi
else
    echo "Error: Missing authorized_keys or backup file for $user."
fi


