import re
from urllib.parse import parse_qs, urljoin, urlparse

import requests
import urllib3
from bs4 import BeautifulSoup
from robot.api import logger
from robot.api.deco import keyword

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)


def write_to_console(s):
    logger.console(s)
    pass

@keyword(name="Filter from list for a given condition dict")
def filter_from_list_based_on_given_condition_dict(
    dictionary: list[dict], identifiers: dict
):
    """
    Returns a list of dicts for a given conditional dict

    ... code:: robotframework
        *** Test Cases ***
        Example
            ${dict}    Create List
            ...    {"name": "Alice", "age": 25}
            ...    {"name": "Bob", "age": 30}
            ...    {"name": "Charlie", "age": 28}
             Evaluate     [item for item in ${dict} if item['name'] == 'Bob' && item['age'] == 30]
    ...

    Args:
        dictionary: a list of dictionaries
        identifiers: dict of key-value pairs need to be matched for the given list of dict
    Returns:
        Returns a list of dicts for a given conditional dict

    """
    return [
        item
        for item in dictionary
        if all(item.get(key) == value for key, value in identifiers.items())
    ]

@keyword(name="Follow redirects")
def follow_redirects(url, stop_condition):
    """
    Follows HTTP and meta-refresh redirects starting from the given URL.

        This function initiates an HTTP GET request to the specified URL and
    follows any redirects, including HTTP status code redirects and
    meta-refresh redirects found within HTML content. It collects the
    status code, URL, and response headers of each redirect in the chain.
    The process stops if a redirect URL contains the substring ``stop_condition``
    or if there are no more redirects to follow.

    Args:
        url (str): The initial URL to request.

    Returns:
        str: The final URL after following all redirects, or None if no redirects were encountered
    """
    session = requests.Session()
    response = session.get(url, allow_redirects=False, verify=False)
    redirect_chain = []
    while response.is_redirect or response.is_permanent_redirect or response.status_code == 200:
        redirect_info = {
            'status_code': response.status_code,
            'url': response.url,
            'headers': dict(response.headers)
        }
        redirect_chain.append(redirect_info)

        if response.status_code == 200:
            # Check for meta-http redirects
            soup = BeautifulSoup(response.content, features="html.parser")

            # Find the meta refresh tag
            meta_refresh = soup.find('meta', attrs={'http-equiv': 'refresh'})

            redirect_url = None
            if meta_refresh:
                # Extract the content attribute
                content = meta_refresh.get('content', '')
                # Use regular expression to find the URL within the content
                match = re.search(r'url=(.*)', content, re.IGNORECASE)
                if match:
                    redirect_url = match.group(1).strip()
        else:
            # Get the redirect URL
            redirect_url = response.headers.get('Location')

        if stop_condition in redirect_url:
            break
        if not redirect_url:
            break

        # Construct the absolute URL if not starting with http
        if (not redirect_url.startswith("http")):
            redirect_url = urljoin(response.url, redirect_url)

        # Follow the redirect
        response = session.get(redirect_url, allow_redirects=False, verify=False)


    return redirect_url


@keyword(name="Get Query Param")
def get_query_param(url, param_name):
    """
    Extracts the value of a query parameter from the given URL.

    Args:
        url (str): The URL containing query parameters.
        param_name (str): The name of the query parameter to extract.

    Returns:
        str: The value of the specified query parameter, or None if not found.
    """
    parsed_url = urlparse(url)
    query_params = parse_qs(parsed_url.query)
    return query_params.get(param_name, [None])[0]

