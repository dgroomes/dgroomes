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


def download(client, url_path, download_file):
    """
    Download data from the GitHub API and write it to a file.

    :param client: The GitHub client
    :param url_path: For example, "/users/dgroomes/repos?per_page=100"
    :param download_file: The file to write the data to. For example, "repos.json"
    :return:
    """
    json = client.get(url_path)

    with open(download_file, 'w') as f:
        f.write(json)

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
