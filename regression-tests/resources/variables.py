import os

from dotenv import load_dotenv
from robot.api import logger

# Load environment variables from .env
load_dotenv()


def write_to_console(s):
    logger.console(s)
    pass


global_variables = {
    "local": {
        "dvp_proxy": "localhost:8801",
        "host": "localhost:9000",
        "max": "localhost:8006",
        "load": "localhost:8808",
        "user_name": "Frouke Jansen",
    },
    "test": {
        "dvp_proxy": "dvp-proxy.test.mgo.irealisatie.nl",
        "host": "localhost:9000",
        "max": "vad.test.mgo.irealisatie.nl",
        "load": "lo-ad.test.mgo.irealisatie.nl",
        "user_name": "Jan van Jansen",
    },
    "acc": {
        "dvp_proxy": "dvp-proxy.acc.mgo.irealisatie.nl",
        "host": "localhost:9000",
        "max": "vad.acc.mgo.irealisatie.nl",
        "load": "lo-ad.acc.mgo.irealisatie.nl",
        "user_name": "Jan van Jansen",
    },
}


def get_variables():
    """Provide Robot tests with Environment specific variables.

    :return: a dictionary with populated variables for the Robot Tests
    """
    env = os.getenv("ENVIRONMENT", "local")
    USER = os.getenv("HTACCESS_USER", "user")
    PASSWORD = os.getenv("HTACCESS_PASSWORD", "pass")

    write_to_console(f"environment is {env}")
    gv = global_variables.get(env, global_variables["local"]).copy()

    config_keys = ["dvp_proxy", "max", "load"]
    if env != "local":
        for key in config_keys:
            gv[key] = f"{USER}:{PASSWORD}@{gv[key]}"
    return gv
