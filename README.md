
# This is the coordination repository for the MGO project.


## Disclaimer

This project and all associated code serve solely as documentation
and demonstration purposes to illustrate potential system
communication patterns and architectures.

This codebase:

- Is NOT intended for production use
- Does NOT represent a final specification
- Should NOT be considered feature-complete or secure
- May contain errors, omissions, or oversimplified implementations
- Has NOT been tested or hardened for real-world scenarios

The code examples are only meant to help understand concepts and demonstrate possibilities.

By using or referencing this code, you acknowledge that you do so at your own
risk and that the authors assume no liability for any consequences of its use.

# Environment setup
In this repository, the End-to-End tests are being maintained. In order, to set up your environment
and contribute to the tests, please read further in the [README under regression-tests](regression-tests/README.md).

# Regression Tests Runs
| Nightly Test Run                   | Status                                             |
|------------------------------------|----------------------------------------------------|
| Test Run against Test env          | [![Morning Run against Test environment](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/morning-on-test.yml/badge.svg?branch=develop)](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/morning-on-test.yml) |
| Test Run against Acc env           | [![Morning Run against Acc environment](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/morning-on-acc.yml/badge.svg?branch=develop)](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/morning-on-acc.yml) |
| Test Run on integration on develop | [![Regression Testing on Integration](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/local-regression-testing.yml/badge.svg)](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/local-regression-testing.yml) |
| Test Run on integration on main    | [![Regression Testing on Integration](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/local-regression-testing.yml/badge.svg?branch=main)](https://github.com/minvws/nl-mgo-coordination-private/actions/workflows/local-regression-testing.yml) |
