#!/bin/bash

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Default values
depth=10
target=""

# Parse flags
while getopts "t:d:" opt; do
  case $opt in
    t) target=$OPTARG ;;
    d) depth=$OPTARG ;;
    *) 
      echo -e "${RED}Usage: $0 -t TARGET_NAME [-d depth]${NC}"
      exit 1
      ;;
  esac
done

# Usage check
if [[ -z "$target" ]]; then
    echo -e "${RED}Usage: $0 -t TARGET_NAME [-d depth]${NC}"
    echo -e "${YELLOW}Example: $0 -t google -d 15${NC}"
    exit 1
fi

# Paths
base_dir=~/bugbounty/targets/$target/subdomains/cero
mkdir -p "$base_dir"

output="$base_dir/all_domains.txt"
scanned="$base_dir/scanned.txt"
timestamp=$(date +"%Y%m%d_%H%M%S")
logfile="$base_dir/log_$timestamp.txt"

# Initialize
echo "$target.com" > "$output"
> "$scanned"
echo -e "${GREEN}[+] Starting recursive cero scan on $target.com (Depth: $depth)${NC}" | tee -a "$logfile"
echo "[+] Log file: $logfile" | tee -a "$logfile"

for ((i=1; i<=depth; i++)); do
    echo -e "${YELLOW}[*] Recursion level $i...${NC}" | tee -a "$logfile"

    new_domains=$(mktemp)
    
    # Find new domains
    comm -23 <(sort -u "$output") <(sort -u "$scanned") > "$new_domains"
    
    if [[ ! -s $new_domains ]]; then
        echo -e "${RED}[*] No new domains found. Stopping early at level $i.${NC}" | tee -a "$logfile"
        break
    fi

    while read sub; do
        echo -e "${YELLOW}[*] Running cero on $sub${NC}" | tee -a "$logfile"

        # Run cero and clean output (*.)
        cero -c 1000 "$sub" 2>/dev/null | sed 's/^\*\.//g' >> "$output"

        # Log each subdomain found
        cero -c 1000 "$sub" 2>/dev/null | sed 's/^\*\.//g' | while read found; do
            echo -e "${GREEN}[+] Found: $found${NC}" | tee -a "$logfile"
        done

        # Mark as scanned
        echo "$sub" >> "$scanned"
    done < "$new_domains"

    # Deduplicate
    sort -u "$output" -o "$output"

    rm "$new_domains"
done

echo -e "${GREEN}[+] Done. All unique domains saved to $output${NC}" | tee -a "$logfile"

# Cleanup temp files
rm -f "$scanned"
