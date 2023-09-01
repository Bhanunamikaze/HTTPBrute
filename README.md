# HTTPBrute
Simple HTTP Bruteforcer

This Python script is a simple HTTP brute-forcing tool designed to test the authentication security of web applications by attempting different combinations of usernames, passwords, and URLs. It leverages multi-threading to perform concurrent HTTP requests, providing efficient and rapid testing.


## Install

```
git clone [https://github.com/Bhanunamikaze/ESXiBrute.git](https://github.com/Bhanunamikaze/HTTPBrute.git)
cd HTTPBrute
python HTTPBrute.py -u root -P /usr/share/wordlists/ssh_usernames.txt -url http://127.0.0.1 -m POST -e 401 -t 30
```

## Features
- Parallel execution of HTTP requests for efficiency.
- Support for testing multiple combinations of usernames, passwords, URLs, and HTTP methods.
- Customizable exclusion and inclusion of specific HTTP response status codes (Exclude or show specific HTTP response status codes.)
- Progress bar to visualize the progress of requests.
- Display of response codes and error messages for diagnosis.
- Supports various HTTP methods (GET by default).

## Usage

```
python HTTPBrute.py -u root -P /usr/share/wordlists/ssh_usernames.txt -url http://127.0.0.1 -m POST -e 401 -t 30

usage: HTTPBrute.py [-h] [-u USERNAME] [-U USERNAMES_FILE] [-p PASSWORD] [-P PASSWORDS_FILE] [-url URL] [-urls URLS_FILE] [-m HTTP_METHOD]
               [-e EXCLUDE_STATUS] [-s SHOW_STATUS] [-t THREADS]

Simple HTTP Multi Threaded Bruteforcer

options:
  -h, --help            show this help message and exit
  -u USERNAME, --username USERNAME
                        Specify a single username
  -U USERNAMES_FILE, --usernames_file USERNAMES_FILE
                        Specify a file containing a list of usernames (one per line)
  -p PASSWORD, --password PASSWORD
                        Specify a single password
  -P PASSWORDS_FILE, --passwords_file PASSWORDS_FILE
                        Specify a file containing a list of passwords (one per line)
  -url URL, --url URL   Specify a single URL
  -urls URLS_FILE, --urls_file URLS_FILE
                        Specify a file containing a list of URLs (one per line)
  -m HTTP_METHOD, --http_method HTTP_METHOD
                        Specify the HTTP method (GET by default)
  -e EXCLUDE_STATUS, --exclude_status EXCLUDE_STATUS
                        Specify status codes to exclude (comma-separated)
  -s SHOW_STATUS, --show_status SHOW_STATUS
                        Specify status codes to show only (comma-separated)
  -t THREADS, --threads THREADS
                        Specify the number of threads (default is 4)

```

## Note:
Be responsible when using this tool. Ensure you have proper authorization to perform authentication testing.
Always use it for ethical and legal purposes.
