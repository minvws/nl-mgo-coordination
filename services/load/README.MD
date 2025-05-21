# LOAD

## Description
Localization and Addressing API. Uses the ZorgAB API to get information on healthcare providers and services.

## Functionality
- Search the ZorgAB API for healthcare providers and services using city and healthcare provider name.
- Import the ZAL (ZorgAanbiedersLijst) to database using cron
- Import the ZAKL (ZorgAanbiederKoppelLijst) to database using cron
- Enrich ZorgAB API responses with dataservice (gegevensdienst) information from the ZAL and ZAKL
- Signing dataservice endpoints using assymetric encryption

## Who uses this service?
- IOS app
- Android app
- Web app

## Keys/Secrets
keys and the configuration keys pointing to the key files.

### ZorgAB
- ZorgAB CA certificate chain (zorgab.mtls_cert_file) used to connect to ZorgAB
- ZorgAB cert  (zorgab.mtls_key_file) used to connect to ZorgAB
- ZorgAB key (zorgab.mtls_chain_file) used to connect to ZorgAB

### Signing
- Private key (signing.private_key_path) Used to sign the dataservice endpoints

### SSL
- Server cert (uvicorn.ssl_cert_file) used to provide HTTPS 
- Server key (uvicorn.ssl_key_file)  used to provide HTTPS 

## Repository 
https://github.com/minvws/nl-mgo-localization-private