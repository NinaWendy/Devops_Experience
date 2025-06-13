
```sh
#!/bin/bash

# Initialize compliance report
REPORT_FILE="/tmp/server_compliance_$(date +%Y%m%d%H%M%S).json"
echo '{"checks": []}' > $REPORT_FILE

# Utility function for adding check results
add_check() {
    jq --arg check "$1" --arg status "$2" --arg message "$3" \
    '.checks += [{"check": $check, "status": $status, "message": $message}]' \
    $REPORT_FILE > tmp.json && mv tmp.json $REPORT_FILE
}

# 1. Netplan Static IP Check
netplan_file=$(ls /etc/netplan/*.yaml 2>/dev/null | head -n1)
if [ -f "$netplan_file" ]; then
    static_ip_check=$(yq e '.network.ethernets.*.addresses[] | select(type == "array")' $netplan_file)
    [ -n "$static_ip_check" ] && status="PASS" || status="FAIL"
    add_check "static_ip" "$status" "Static IP configured in $netplan_file"
else
    add_check "static_ip" "FAIL" "No Netplan configuration found"
fi

# 2. SSH Configuration Checks
sshd_config="/etc/ssh/sshd_config"
declare -A ssh_checks=(
    ["RootLogin"]="^PermitRootLogin no"
    ["PasswordAuth"]="^PasswordAuthentication no"
    ["PubkeyAuth"]="^PubkeyAuthentication yes"
)

for key in "${!ssh_checks[@]}"; do
    grep -qP "${ssh_checks[$key]}" $sshd_config
    [ $? -eq 0 ] && status="PASS" || status="FAIL"
    add_check "ssh_$key" "$status" "${ssh_checks[$key]}"
done

# 3. User Configuration Check
target_user="ubuntu"
getent passwd $target_user >/dev/null
if [ $? -eq 0 ]; then
    ssh_dir="/home/$target_user/.ssh"
    auth_keys="$ssh_dir/authorized_keys"
    
    [ -d "$ssh_dir" ] && dir_perm=$(stat -c "%a" $ssh_dir)
    [ "$dir_perm" == "700" ] && status="PASS" || status="FAIL"
    add_check "ssh_dir_perms" "$status" "$ssh_dir permissions: $dir_perm"

    [ -f "$auth_keys" ] && file_perm=$(stat -c "%a" $auth_keys)
    [ "$file_perm" == "600" ] && status="PASS" || status="FAIL"
    add_check "authkey_perms" "$status" "$auth_keys permissions: $file_perm"
else
    add_check "user_config" "FAIL" "User $target_user not found"
fi

# 4. Sudoers Configuration Check
sudoers_check=$(grep -P "^%sudo\\s+ALL=(ALL:ALL)\\s+NOPASSWD:ALL" /etc/sudoers)
[ -n "$sudoers_check" ] && status="PASS" || status="FAIL"
add_check "sudoers_config" "$status" "Passwordless sudo configuration"

# 5. Fail2ban Service Check
if systemctl is-active fail2ban >/dev/null; then
    add_check "fail2ban" "PASS" "Fail2ban service is active"
else
    add_check "fail2ban" "FAIL" "Fail2ban service not running"
fi

# Generate final report
echo "Compliance check complete. Report generated at: $REPORT_FILE"
jq '.' $REPORT_FILE

```

## Requirements

Install jq(JSON processing)
sudo apt-get update
sudo apt-get install jq

Install yq(YAML processing)
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod a+x /usr/local/bin/yq