#!/bin/bash

# Get domain name as input from the user when the script executes
read -p "Enter the domain name: " full_domain

# Extract the base domain name without the extension
domain_name=$(echo "$full_domain" | awk -F'.' '{print $1}')

if [ -z "$domain_name" ]; then
  echo "Invalid domain name provided. Exiting."
  exit 1
fi

# Create a text file to store output
touch "${domain_name}_subdomains.txt"

# Use amass to do subdomain enumeration
# Redirect the output to a text file
amass enum -ip -brute -min-for-recursive 2 -d "$full_domain" > "${domain_name}_subdomains.txt"

# Convert the text file to a CSV file using csvkit
# Split the subdomain name from the IP address into two columns
# Name the two columns as Subdomain and IP Address
csvformat -T -H -D "," "${domain_name}_subdomains.txt" | \
awk -F, '{print $1 "," $2}' | \
sed '1s/.*/Subdomain,IP Address/' > "${domain_name}_subdomains.csv"

# Optionally, you can use a tool like csv2xlsx to convert the CSV to Excel if needed
# csv2xlsx "${domain_name}_subdomains.csv" "${domain_name}_subdomains.xlsx"

echo "Subdomain enumeration and CSV conversion complete. Results saved in ${domain_name}_subdomains.csv"
