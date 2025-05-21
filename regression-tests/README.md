# Test Execution

## Run the tests against the Integration
There are 2 ways to run the tests against the integration.

For either way you need to first have the other services up & running.
Please refer to the [integration's Readme](integration/README.md) for detailed steps on how to do that.

Once you have the other services healthy, you can either
1. run tests using docker and for that, you can make use of the [runtests-in-docker.sh](runtests-in-docker.sh) script.
2. run the tests using `robot`, for that you need to follow the [Environment setup](#environment-setup) steps.


To contribute to the development of the regression tests, please follow the steps below in order to set up
your environment.

# Environment setup
1. Clone the repository [nl-mgo-coordination-private](https://github.com/minvws/nl-mgo-coordination-private) from Github
2. Install Python 3.12 on your machine and then install `pip`.

   ```python3.12 -m pip install --upgrade pip```
3. Start a new virtual environment on the root folder of this project, using Python 3.12, and activate it.

   ```bash
   pip install virtualenv
   virtualenv venv
   source venv/bin/activate
   ```
4. First tool to install would be the [`pip-tools`](https://github.com/jazzband/pip-tools).
   A set of command line tools to help you keep your pip-based packages fresh, even when you've pinned them.
   This way we can have the essential packages for this project pinned in the `requirements.in` and with that we can construct the
   `requirements.txt` file that should be used when installing packages. When you want to update some packages,
   all you need to do is update the `requirements.in` file and then re-compile the `requirements.txt` one.
   So do `python -m pip install pip-tools` inside your activated pip environment.
   When you need to compile a new version of the `requirements.txt`, do `pip-compile --output-file=- > requirements.txt`
   inside the `regression-tests` folder.
5. Install the pip libraries required:
   ```bash
   pip3 install -r regression-tests/requirements.txt
   ```
6. Run `rfbrowser init` in order to initialize the Browser library with new node dependencies
7. Execute the tests using the `regression-tests/runtests.sh` script