#!/bin/bash

username=""
usernames_file=""
password=""
passwords_file=""
url=""
urls_file=""
http_method="GET"
exclude_status=""
show_status=""

print_usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "OPTIONS:"
  echo "  -u <username>        : Specify a single username"
  echo "  -U <usernames_file>  : Specify a file containing a list of usernames (one per line)"
  echo "  -p <password>        : Specify a single password"
  echo "  -P <passwords_file>  : Specify a file containing a list of passwords (one per line)"
  echo "  -url <url>           : Specify a single URL"
  echo "  -urls <urls_file>    : Specify a file containing a list of URLs (one per line)"
  echo "  -m <http_method>     : Specify the HTTP method (GET by default)"
  echo "  -e <status_codes>    : Specify status codes to exclude (comma-separated)"
  echo "  -s <status_codes>    : Specify status codes to show only (comma-separated)"
  exit 1
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -u)
      username="$2"
      shift 2
      ;;
    -U)
      usernames_file="$2"
      shift 2
      ;;
    -p)
      password="$2"
      shift 2
      ;;
    -P)
      passwords_file="$2"
      shift 2
      ;;
    -url)
      url="$2"
      shift 2
      ;;
    -urls)
      urls_file="$2"
      shift 2
      ;;
    -m)
      http_method="$2"
      shift 2
      ;;
    -e)
      exclude_status="$2"
      shift 2
      ;;
    -s)
      show_status="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      ;;
  esac
done

# Check if either username or usernames_file is provided
if [ -z "$username" ] && [ -z "$usernames_file" ]; then
  echo "Either a single username (-u) or a file containing usernames (-U) is required."
  print_usage
fi

# Check if at least one of password or passwords_file is provided
if [ -z "$password" ] && [ -z "$passwords_file" ]; then
  echo "Either a single password (-p) or a file containing passwords (-P) is required."
  print_usage
fi

# Check if either URL or URLs file is not provided
if [ -z "$url" ] && [ -z "$urls_file" ]; then
  echo "Either a single URL (-url) or a file containing URLs (-urls) is required."
  print_usage
fi


read_values_from_file() {
  local file="$1"
  while IFS= read -r line; do
    echo "$line"
  done < "$file"
}

if [ -n "$usernames_file" ]; then
  usernames=($(read_values_from_file "$usernames_file"))
else
  usernames=("$username")
fi

if [ -n "$passwords_file" ]; then
  passwords=($(read_values_from_file "$passwords_file"))
else
  passwords=("$password")
fi

if [ -n "$urls_file" ]; then
  urls=($(read_values_from_file "$urls_file"))
else
  urls=("$url")
fi

should_exclude() {
  local code="$1"
  IFS=',' read -ra exclude_codes <<< "$exclude_status"
  for ec in "${exclude_codes[@]}"; do
    if [ "$ec" == "$code" ]; then
      return 0 
    fi
  done
  return 1 
}


should_show() {
  local code="$1"
  IFS=',' read -ra show_codes <<< "$show_status"
  for sc in "${show_codes[@]}"; do
    if [ "$sc" == "$code" ]; then
      return 0 
    fi
  done
  return 1 
}

for u in "${usernames[@]}"; do
  for p in "${passwords[@]}"; do
    for u2 in "${urls[@]}"; do

      # Make a curl request and get the response status code
      response_code=$(curl -ks -o /dev/null -w "%{http_code}" -X "$http_method" "$u2" -u "$u":"$p")

      if [ -n "$exclude_status" ]; then
        # If exclude_status is specified, check if the status code should be excluded
        if should_exclude "$response_code"; then
          continue 
        fi
      fi

      if [ -n "$show_status" ]; then
        # If show_status is specified, check if the status code should be shown only
        if should_show "$response_code"; then
          echo "URL: $u2 - Username: $u - Password: $p - HTTP Method: $http_method - Response Code: $response_code"
        fi
      else
        # If show_status is not specified, print all responses
        echo "URL: $u2 - Username: $u - Password: $p - HTTP Method: $http_method - Response Code: $response_code"
      fi
    done
  done
done
