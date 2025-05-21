import os

global_variables = {}

global_variables["local"] = {
    "dvp_proxy": "localhost:8801",
    "host": "http://localhost:9000",
    "max": "https://localhost:8006",
    "load": None,
    "user_name": "Frouke Jansen",
}

global_variables["test"] = {
    "dvp_proxy": "dvp-proxy.test.mgo.irealisatie.nl",
    "host": "http://localhost:9000",  # VAD_POC is not yet on Test env
    "max": "https://vad.test.mgo.irealisatie.nl",
    "load": "lo-ad.test.mgo.irealisatie.nl",
    "user_name": "Jan van Jansen",
}



def get_variables():
    """Provide Robot tests with Environment specific variables.

    :return: a dictionary with populated variables for the Robot Tests
    """

    print(f"Function::environment {os.environ['environment']}")
    gv = global_variables.get(os.environ['environment'], global_variables["local"])
    print(f"Function::dvp_proxy {global_variables[os.environ['environment']]['dvp_proxy']}", )
    return gv