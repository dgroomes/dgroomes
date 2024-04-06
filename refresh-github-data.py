import json
import os
import sys
from http.client import HTTPSConnection

"""
Refresh the GitHub repositories or gists data.

This makes requests to the GitHub API, runs the data through jq, and writes the final 
"""

GITHUB_API_HOST = "api.github.com"
USER = "dgroomes"
PER_PAGE = 100
PAGE_SAFEGUARD_LIMIT = 10


class GitHubClient:
    """
    A client for the GitHub REST API.
    """

    def __init__(self, host, personal_access_token):
        """
        Initialize the client with the GitHub API hostname and GitHub personal access token (PAT).
        :param host: For example, "api.github.com"
        :param personal_access_token:
        """

        self.conn = HTTPSConnection(host)
        # Optionally, enable debugging to see the HTTP request/response
        # self.conn.set_debuglevel(1)

        self.headers = {
            'Accept': 'application/vnd.github.v3+json',
            'Authorization': f'Bearer {personal_access_token}',
            'User-Agent': 'python'
        }

    def get(self, url_path):
        """
        Make a GET request to the GitHub API.
        :param url_path: For example, "/users/dgroomes/repos?per_page=100"
        :return: the response body as a string
        """

        self.conn.request('GET', url_path, headers=self.headers)
        response = self.conn.getresponse()

        if response.status != 200:
            print(f"Error: GET request failed. Status code: {response.status}. Body: ")
            print(response.read().decode())
            sys.exit(1)

        return response.read().decode()


def download(client, base_url_path, download_file):
    """
    Download data from the GitHub API for a paginated endpoint and write the data to a file.

    :param client: The GitHub client
    :param base_url_path: For example, "/users/dgroomes/repos"
    :param download_file: The file to write the data to. For example, "repos.json"
    :return:
    """
    data = []
    page = 1
    while page is not None:
        if page >= PAGE_SAFEGUARD_LIMIT:
            print(
                f"Reached the safeguard limit of {PAGE_SAFEGUARD_LIMIT} pages. Stopping. Has something gone "
                "haywire or do you really need to make that many paged requests?")
            sys.exit(1)

        url_path = f"{base_url_path}&page={page}"
        response_json = client.get(url_path)
        response_list = json.loads(response_json)
        data.extend(response_list)

        # Are there more pages worth of data to fetch? We can check the 'Link' header, but we can also just check if the
        # last response was an empty list. If it was, then we're done.
        if len(response_list) == 0:
            break
        page += 1

    with open(download_file, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"Data downloaded to '{download_file}'")


def usage():
    print("Usage: python refresh-github-data.py <repos|gists>")
    sys.exit(1)


def main():
    if len(sys.argv) != 2:
        usage()

    data_type = sys.argv[1]

    personal_access_token = os.environ.get('GITHUB_PAT')
    if personal_access_token is None:
        print("Error: The 'GITHUB_PAT' environment variable is not set")
        sys.exit(1)

    client = GitHubClient(GITHUB_API_HOST, personal_access_token)

    if data_type == "repos":
        url_path = f"/users/{USER}/repos?per_page={PER_PAGE}"
        download(client, url_path, "repos.json")
    elif data_type == "gists":
        url_path = f"/users/{USER}/gists?per_page={PER_PAGE}"
        download(client, url_path, "gists.json")
    else:
        usage()


if __name__ == "__main__":
    main()
