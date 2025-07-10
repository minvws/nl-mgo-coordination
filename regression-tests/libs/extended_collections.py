import re
from urllib.parse import parse_qs, urljoin, urlparse

import requests
import urllib3
from bs4 import BeautifulSoup
from robot.api import logger
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn

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
    Follow HTTP and meta-refresh redirects starting from the given URL until stop condition is met.

    This function sends an initial GET request to the specified URL and follows any redirects.
    For each redirect the HTTP Basic Authentication is applied to each request.
    The redirection chain stops when:
    - A redirect URL contains the specified `stop_condition` substring.
    - No further redirects are encountered.

    Args:
        url (str): The starting URL to initiate the redirection chain.
        stop_condition (str): A substring to look for in redirect URLs that stops further redirection.

    Returns:
        str: The final redirect URL reached before stopping, or None if redirection failed or ended prematurely.

    Notes:
        - Disables SSL verification (`verify=False`) for each request.
        - Requires `${USER}` and `${PASSWORD}` Robot Framework variables for basic authentication.
    """
    global redirect_url_with_basicauth, redirect_url
    session = requests.Session()
    response = session.get(url, allow_redirects=False, verify=False)
    redirect_chain = []
    while (
        response.is_redirect
        or response.is_permanent_redirect
        or response.status_code == 200
    ):
        redirect_info = {
            "status_code": response.status_code,
            "url": response.url,
            "headers": dict(response.headers),
        }
        redirect_chain.append(redirect_info)

        if response.status_code == 200:
            # Check for meta-http redirects
            soup = BeautifulSoup(response.content, features="html.parser")

            # Find the meta refresh tag
            meta_refresh = soup.find("meta", attrs={"http-equiv": "refresh"})

            redirect_url = None
            if meta_refresh:
                # Extract the content attribute
                content = meta_refresh.get("content", "")
                # Use regular expression to find the URL within the content
                match = re.search(r"url=(.*)", content, re.IGNORECASE)
                if match:
                    redirect_url = match.group(1).strip()
        else:
            # Get the redirect URL
            redirect_url = response.headers.get("Location")

        if not redirect_url:
            break
        if stop_condition in redirect_url:
            break

        # Construct the absolute URL if not starting with http
        if not redirect_url.startswith("http"):
            redirect_url = urljoin(response.url, redirect_url)

        # For every url to follow, add the basic auth
        match = re.match(r"(https?)://(.*)", redirect_url)
        if match:
            protocol = match.group(1)
            url_without_protocol = match.group(2)
            user = BuiltIn().get_variable_value("${USER}")
            password = BuiltIn().get_variable_value("${PASSWORD}")
            redirect_url_with_basicauth = (
                f"{protocol}://{user}:{password}@{url_without_protocol}"
            )
        else:
            write_to_console(
                "No protocol found on redirect URLs. This should not have happened."
            )

        # Follow the redirect
        response = session.get(
            redirect_url_with_basicauth, allow_redirects=False, verify=False
        )

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
