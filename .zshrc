# Fzf
alias lsf='ls | fzf'
alias pf='ps aux | fzf'

## Fzf-based zsh history search
history-search() {
  if [ -z "$1" ]; then
    cat ~/.zsh_history | cut -d';' -f2- | fzf --tac --no-sort | sed "s/^[ ]*[0-9]*[ ]*//"
  else
    cat ~/.zsh_history | cut -d';' -f2- | grep "$@" | fzf --tac --no-sort | sed "s/^[ ]*[0-9]*[ ]*//"
  fi
}

## Fzf-based big directory search and cd 
search-bigdir() {
  local dir
  dir=$(du -h -d 1 . 2>/dev/null \
        | sort -rh \
        | head -20 \
        | awk '$2 != "."' \
        | fzf \
            --preview 'du -h -d 1 {2} 2>/dev/null | sort -rh' \
            --preview-window=right:60% \
        | awk '{print $2}')

  [[ -n "$dir" ]] && cd "$dir"
}

# Fzf-based listening ports
ports() {
  local opener
  if command -v open >/dev/null; then
    opener="open"
  else
    opener="xdg-open"
  fi

  local selection key pid port

  selection=$(
    lsof -iTCP -sTCP:LISTEN -Pn 2>/dev/null \
    | awk 'NR>1 {
        port = substr($9, index($9, ":")+1)
        printf "%s\t%s\t%s\n", $2, $1, port
      }' \
    | fzf \
        --prompt="Listening ports > " \
        --height=40% \
        --delimiter='\t' \
        --with-nth=2,3 \
        --expect=enter,space
  )

  key=$(echo "$selection" | head -n1)
  line=$(echo "$selection" | sed -n '2p')

  [[ -z "$line" ]] && return

  pid=$(echo "$line" | cut -f1)
  port=$(echo "$line" | cut -f3)

  case "$key" in
    enter)
      kill -9 "$pid"
      ;;
    space)
      "$opener" "http://localhost:$port" >/dev/null 2>&1
      ;;
  esac
}





## Pomodoro Timer
alias work="timer 60m && terminal-notifier\
		-message 'You have been working for 60 minutes. Take a break!'\
		-title 'Timer'\
		-sound Crystal"

alias rest="timer 15m && terminal-notifier\
		-message 'Your break is over. Get back to work!'\
		-title 'Timer'\
		-sound Crystal"

# Open Arc browser or search with Arc 
Arc() {
  if [[ $# -eq 0 ]]; then
    open -a "Arc"
  else
    local query
    query=$(printf "%s " "$@")
    open -a "Arc" "https://www.google.com/search?q=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$query")"
  fi
}

# Utilities
# Password Generator
pswgen() {
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  CYAN='\033[0;36m'
  NC='\033[0m' 

  while true; do
    echo -ne "${YELLOW}Type a length (default 16) >> ${NC}"
    read len
    len=${len:-16}

    if [[ "$len" =~ ^[0-9]+$ && "$len" -ge 16 ]]; then
      break
    else
      echo -e "${RED}Invalid length. Please enter a number greater than or equal to 16.${NC}"
    fi
  done  

  echo -e "${CYAN}---> Charset <---${NC}"
  echo -e "${CYAN}
    \t1 | Only letters 
    \n\t2 | Only numbers 
    \n\t3 | Only letters and numbers 
    \n\t4 | Letters, numbers and symbols
  ${NC}"
  echo -e "${CYAN}---> Charset <---${NC}"

  while true; do
    echo -ne "${YELLOW}Choice [1-4] >> ${NC}"
    read type
    type=${type:-4}

    if [[ "$type" =~ ^[1-4]$ ]]; then
      break
    else
      echo -e "${RED}Invalid type. Please enter a number from 1 to 4.${NC}"
    fi
  done

  case $type in
    4) charset='A-Za-z0-9!@#$%^&*+='; charset_size=72 ;;
    3) charset='A-Za-z0-9'; charset_size=62 ;;
    2) charset='0-9'; charset_size=10 ;;
    1) charset='A-Za-z'; charset_size=52 ;;
    *) echo -e "${RED}Invalid type${NC}"; return ;;
  esac

  pass=$(LC_ALL=C tr -dc "$charset" < /dev/urandom | head -c "$len")

  if [[ -z "$pass" ]]; then
    echo -e "${RED}Error generating password${NC}"
    return
  fi

  if command -v bc &> /dev/null; then
    entropy=$(awk -v l="$len" -v c="$charset_size" 'BEGIN { print l * log(c)/log(2) }')
    if (( $(echo "$entropy < 60" | bc -l) )); then
      strength="${RED}Weak${NC}"
    elif (( $(echo "$entropy < 100" | bc -l) )); then
      strength="${YELLOW}Medium${NC}"
    else
      strength="${GREEN}Strong${NC}"
    fi
    echo -e "\n${CYAN}Key | Password strength: ${strength}.${NC}\n"
  else
    echo -e  "${RED}I can't calculate entropy. Please install bc${NC}"
  fi

  echo -ne "${YELLOW}Key | Do you want to copy it? (y/n) ${NC}"
  read copythat

  case $copythat in
    [yY])
      if command -v xclip &> /dev/null; then
        echo -n "$pass" | xclip -selection clipboard
        echo -e "${GREEN}Key | Password copied using xclip.${NC}"
      elif command -v pbcopy &> /dev/null; then
        echo -n "$pass" | pbcopy
        echo -e "${GREEN}Key | Password copied using pbcopy.${NC}"
      else
        echo -e "${YELLOW}Key | Clipboard tool not found. Your password >> ${pass}${NC}"
      fi
      ;;
    [nN]) echo -e "${CYAN}Key | Password: ${pass}${NC}" ;;
    *)    echo -e "${RED}! | Unrecognized input. Password: ${pass}${NC}" ;;
  esac
}




iplookup() {

  if ! command -v jq &> /dev/null; then
    echo "IP Lookup | Jq not found. Please, install jq to continue."
    return 1
  fi

  if [[ -z "$1" ]]; then
    while true; do
      echo -ne "IP Address (leave blank to use your IP)>> "
      read ip
      
      if [[ "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        break
      elif [[ -z "$ip" ]]; then
        ip=$(curl -s ifconfig.me)
        break
      else
        echo "IP Lookup | Invalid IP format. Please enter a valid IP address."
      fi
    done  
  fi

  local response
  response=$(curl -s "https://ipwho.is/$ip")

  if [[ $? -ne 0 || -z "$response" ]]; then
    echo "IP Lookup | Request Error."
    return 1
  fi

  local success=$(echo "$response" | jq -r '.success')
  if [[ "$success" == "false" ]]; then
    local msg=$(echo "$response" | jq -r '.message')
    echo "IP Lookup | API Error >> $msg"
    return 1
  fi

  eval $(echo "$response" | jq -r '
    "type=\(.type)
     ip=\(.ip)
     city=\(.city)
     region=\(.region_code)
     regionName=\(.region)
     country=\(.country)"'
  )

  echo -e "\n"
  echo "---> $type | $ip <---"

  echo -e "
  \t | City >> $city
  \n\t | Region >> $region - $regionName
  \n\t | Country >> $country
  "

  echo "---> $type | $ip <---"
}




tmpcleaner() {
  local DRY_RUN=false
  local TARGET_DIR

  while true; do
    echo -n "Cleaner | Do you want to perform a dry-run? (y/n) >> "
    read dry_input
    case "$dry_input" in
      [yY])
        DRY_RUN=true
        break
        ;;
      [nN])
        DRY_RUN=false
        break
        ;;
      *)
        echo "Cleaner | Invalid input. Please enter 'y' or 'n'."
        ;;
    esac
  done

  while true; do
    echo -n "Cleaner | Enter the target directory (leave blank for current dir '.') >> "
    read TARGET_DIR
    TARGET_DIR="${TARGET_DIR:-.}"

    if [[ -d "$TARGET_DIR" ]]; then
      break
    else
      echo "Cleaner | Error >> '$TARGET_DIR' isn't a valid directory. Try again."
    fi
  done

  echo "Cleaner | Scanning temporary files in >> $TARGET_DIR"
  [[ "$DRY_RUN" == true ]] && echo "Cleaner | No files will be deleted with dry-run"

  local extensions=("*.tmp" "*~" "*.bak" "*.swp" "*.log" ".DS_STORE")

  for ext in "${extensions[@]}"; do
    find "$TARGET_DIR" -type f -name "$ext" 2>/dev/null | while read -r file; do
      if [[ "$DRY_RUN" == true ]]; then
        echo "Cleaner | DRY-RUN >> Found $file"
      else
        echo "Cleaner | Removed >> $file"
        rm -f "$file"
      fi
    done
  done

  echo "Cleaner | Cleaning Complete"
}

# AWS Profiles 
awsp() {
    local profiles=()
    
    [[ -f ~/.aws/credentials ]] && profiles+=($(grep '^\[' ~/.aws/credentials | tr -d '[]'))
    [[ -f ~/.aws/config ]] && profiles+=($(grep '^\[profile' ~/.aws/config | sed 's/\[profile //' | tr -d ']'))
    profiles=($(echo "${profiles[@]}" | tr ' ' '\n' | sort -u))
    
    if [[ ${#profiles[@]} -eq 0 ]]; then
        echo "No AWS profiles found in ~/.aws/credentials"
        return 1
    fi
    
    local selected
    if command -v fzf &> /dev/null; then
        selected=$(printf '%s\n' "${profiles[@]}" | fzf --prompt="AWS Profile -> " --height=40% --reverse)
    else
        echo "Select profile:"
        select p in "${profiles[@]}"; do selected="$p"; break; done
    fi

    [[ -z "$selected" ]] && return 1
    
    if [[ $# -gt 0 ]]; then
        echo "[$selected] → $@"
        AWS_PROFILE="$selected" "$@"
    else
        export AWS_PROFILE="$selected"
        echo "AWS_PROFILE=$selected (session)"
    fi
}

eval "$(rbenv init - zsh)"
eval "$(~/.local/bin/mise activate)"

# Added by Antigravity
export PATH="/Users/mcha/.antigravity/antigravity/bin:$PATH"

# ai-commit
alias ai-commit="~/.local/bin/ai-commit.sh"


