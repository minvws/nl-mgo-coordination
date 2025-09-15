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
2. Install Python 3.13 on your machine and then install `pip`.

   ```bash
   python3.13.5 -m pip install --upgrade pip
   ```
3. You can either use the Makefile to install all the needed dependencies, or follow the steps below.
Using the Makefile would be like this:
   ```bash
   make install-robot
   ```
If you choose to install the dependencies manually, see the following steps:
   1. For the regression-tests, we are using [`poetry`](https://github.com/python-poetry/poetry) as the main dependency management tool.
      Given you are in the `regression-tests` directory, do:
      ```bash
      pip3 install poetry
      ```
   2. Use poetry to create a new virtual environment `.venv` and install the dependencies inside it:
      ```bash
      poetry install
      eval $(poetry env activate)
      ```
      Should you need to add more packages to your project, you can easily do that with `poetry add PACKAGE`.
      This way poetry adds the package to your `pyproject.toml` and the `poetry.lock` files.
      You can update packages using `poetry update`, followed up by `poetry lock`.

   3. Once you have the virtual environment activated, do `rfbrowser init` in order to initialize the Browser library with new node dependencies
   4. Copy the content of the `regression-tests/.env.example` to a `.env` file and add the credentials.
   5. Finally, execute the tests using the `regression-tests/runtests.sh` script to run them with `robot` directly on your machine 
   or use the make target: `make test`. 
   `make test` will run the tests locally, unless amended on the .env file. Alternatively, you can override the .env setting
   with `make test environment=test`.

Keep calm and Robot Framework on 🤖!