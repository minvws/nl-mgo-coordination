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
        "DVP_PROXY": "localhost:8801",
        "HOST": "localhost:9000",
        "MAX": "localhost:8006",
        "LOAD": "localhost:8808",
        "USER_NAME": "Frouke Jansen",
        "CBP": "localhost:8008",
    },
    "test": {
        "DVP_PROXY": "dvp-proxy.test.mgo.irealisatie.nl",
        "HOST": "localhost:9000",
        "MAX": "vad.test.mgo.irealisatie.nl",
        "LOAD": "lo-ad.test.mgo.irealisatie.nl",
        "USER_NAME": "Jan van Jansen",
        "CBP": "https://cbp.test.mgo.irealisatie.nl",
    },
    "acc": {
        "DVP_PROXY": "dvp-proxy.acc.mgo.irealisatie.nl",
        "HOST": "localhost:9000",
        "MAX": "vad.acc.mgo.irealisatie.nl",
        "LOAD": "lo-ad.acc.mgo.irealisatie.nl",
        "USER_NAME": "Jan van Jansen",
        "CBP": "https://cbp.acc.mgo.irealisatie.nl",
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

    config_keys = ["DVP_PROXY", "MAX", "LOAD"]
    if env != "local":
        for key in config_keys:
            gv[key] = f"{USER}:{PASSWORD}@{gv[key]}"
    return gv
