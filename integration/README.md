# mgo-integration

An integration environment connecting multiple MGO backend services, allowing for seamless navigation across all VAD-related services.

This platform is used for development and integration testing.

## Table of Contents

- [Definitions](#definitions)
- [Overview](#overview)
- [Features](#features)
- [Service composition](#service-composition)
- [Installation](#installation)
  - [Prerequisites](#prerequisites)
  - [Set-up](#set-up)
- [Demo](#demo)
  - [DVP Functionality Demonstrated](#dvp-functionality-demonstrated)
  - [DVA](#dva)
  - [PRS api](#prs-api)
- [Usage / Customizations](#usage--customizations)
  - [BRP](#brp)

(#. NDA)

## Definitions

| Abbreviation | Term                             | Description                                                                                                                                        |
| ------------ | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **BSN**      | BurgerServiceNummer              | Dutch equivalent of a Social Security Number, assigned to every Dutch citizen.                                                                     |
| **PII**      | Personally Identifiable Info     | Information that can be used to identify a person.                                                                                                 |
| **PDN**      | Pseudonym                        | A deterministic, organisation-specific pseudonym for a PII (Personally Identifiable Information).                                                  |
| **RID**      | Reference ID                     | A unique identifier that can be used to retrieve a pseudonym                                                                                       |
| **BRP**      | BasisRegistratie Personen        | Dutch Personal Records Database. Contains information about Dutch citizens.                                                                        |
| **DigiD**    | Digitale Identiteit              | Dutch digital identity system. Used to authenticate Dutch citizens on various government websites based on their BSN.                              |
| **VAD**      | Vertrouwde AuthenticatieDienst   | Trusted Authentication Service. Used to describe the interconnected services that facilitate DigiD login, BRP data enrichment and Pseudonymization |
| **DVA**      | DienstVerlener Aanbieder         | Service Provider Provider. A service that provides services to a service provider (usually a healthcare provider)                                  |
| **DVP**      | DienstVerlener Persoon           | Service Provider Person. A service (usually a PGO) that provides services to a person.                                                             |
| **TVS**      | ToegangsVerlenings service       | Access providing service. A service that provides multiple login methods that all lead to PII for a user  that is logging in.                      |
| **MAX**      | Multiple Authentication Exchange | A service that acts as a bridge between the authentication server (TVS) and the OIDC service. In this proof of concept TVS is mocked by MAX.       |
| **VAD**     | Vertrouwde AuthenticatieDienst     | A module within MAX that provides extended user information together with a [RID](#definitions) and [PDN](#definitions) allowing external healthcare systems to retrieve user information without sharing privacy sensitive authentication identifiers. In the end VAD will become an application on it's own using MAX as base framework to operate on.                              |

## Overview

This project is a proof of concept for the [VAD](#definitions). It aims to demonstrate how [DVP](#definitions) clients without authorization to handle a [BSN / PII](#definitions) can be authenticated and enabled to request sensitive data linked to the [BSN/ PII](#definitions) on behalf of a Dutch citizen from healthcare providers.

In order to demonstrate the authentication flow in its entirety, this project includes both the services that make up the [VAD](#definitions) and several additional integral services, like [PRS](#definitions). Also two demo applications are provided, one representing a [DVP](#definitions) client and the other a [DVA](#definitions), improving the ease with which the authentication flow is tested/demonstrated.

## Features

The key features of this proof of concept are listed below.

- As [DVP](#definitions) client on behalf of a Dutch citizen, authenticate via (mock) DigiD
- As [DVP](#definitions) client on behalf of a Dutch citizen, receive that citizen's name and age, as well as a [RID](#definitions) and a [PDN](#definitions)
- As [DVP](#definitions) client on behalf of a Dutch citizen, request private data pertaining to said citizen using the [RID](#definitions) as identification
- As [DVA](#definitions), swap an incoming [RID](#definitions) for a DVA-unique [PDN](#definitions) that can be linked to the actual [BSN / PII](#definitions)

## Service composition

As mentioned before, this project consists of several services working together to enable the [VAD](#definitions) to function. The following overview lists all those services and their purpose.

| Service Name       | Description                                                                                                                                                                                                                                                      |
| ------------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **MAX**            | Being the [VAD](#definitions) entrypoint, it acts as a bridge between the authentication server ([TVS](#definitions)) and the OIDC service. In this proof of concept [TVS](#definitions) is mocked by [MAX](#definitions) and therefore has no separate service. |
| **LUIS**           | The OIDC service responsible for gathering "userinfo", i.e. the personal details via [BRP](#definitions) and the [RID and PDN](#definitions) via [PRS](#definitions).                                                                                            |
| **PRS**            | An exchange service providing [RIDs and PDNs](#definitions) to [DVP](#definitions) clients and enabling [DVA's](#definitions) to exchange a given [RID](#definitions) for a [PDN](#definitions) it can link to an actual [BSN](#definitions).                    |
| **DVP**            | A demo application demonstrating an example [VAD](#definitions) authentication implementation.                                                                                                                                                                   |
| **DVA**            | A demo application demonstrating an example [PRS](#definitions) exchange implementation.                                                                                                                                                                         |
| **Redis**          | Facilitates state storage for [MAX](#definitions) during authentication                                                                                                                                                                                          |
| **Secret Manager** | Distributes public certificates to other services in the network used for decryption and/or signature validation                                                                                                                                                 |
| **BRP**            | Provides fake personal data for a [BSN](#definitions)                                                                                                                                                                                                            |

## Installation

Follow the steps below to run this integration setup on your local machine.

### Prerequisites

Please install the below programs if not present:

- [Docker](https://www.docker.com/)
- [Git](https://git-scm.com/)
- [Make](https://www.gnu.org/software/make/)

### Setup Guide

After cloning this repository, follow the steps below to set up the project and its dependencies.

#### 1. Initialize Git Submodules

From the root of the repository, initialize all required Git submodules:

```sh
make submodules-init
```

#### 2. Configure NPM authentication

In order to be able to pull the npm assets, you need to provide the GITHUB TOKEN.
You can do that by adding your GITHUB_TOKEN to your `~/.npmrc`.
Add to your `~/.npmrc` file, the following:
```bash
//npm.pkg.github.com/:_authToken=<YOUR_GITHUB_TOKEN>
```

#### 3. Navigate to the Integration Folder

Change to the working directory, `integration`, where the necessary configurations are located:

```sh
cd integration
```

#### 4. Build Docker Containers

Next, build the Docker containers for the project:

```sh
make build
```

#### 4. Start the Services

Finally, start the docker services:

```sh
make start
```

## Demo

### DVP Functionality Demonstrated

The web app can be found at: [http://localhost:9000/](http://localhost:9000/)

This application showcases the following [DVP](#definitions) functionalities:

1. Login with DigiD (mock) and return user information along with [PDN/RID](#definitions).
2. Retrieve a person's information from the [DVA](#definitions) using a [RID](#definitions).
3. Retrieve multiple new [RID](#definitions) values using an existing [RID](#definitions).

### DVA

The [DVA](#definitions) is a simple dummy version of a [DVA](#definitions) application used in the [DVP](#definitions) demo app to retrieve a person's information based on a given [RID](#definitions). The [DVA](#definitions) interacts with the [PRS](#definitions) to retrieve a [PDN](#definitions), which can be used to identify the user in the [DVA's](#definitions) database.

You can access the API documentation for the [DVA](#definitions) at:
[http://localhost:8001/docs](http://localhost:8001/docs)

### PRS api

You can access the API documentation of [PRS](#definitions) at:
[http://localhost:8005/docs](http://localhost:8005/docs)

## Usage / Customizations

### BRP

Test data in the [BRP](#definitions) mock container can be changed or extended by changing docker/brp/assets/data/test-data.json which is mounted in the 'brp' container.
