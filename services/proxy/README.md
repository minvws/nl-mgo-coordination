# DVP Proxy

## Description
The DVP (Dienstverlener Persoon Proxy) is a proxy that acts as a secure gateway between the clients and the DVA FHIR Servers. It forwards requests from the clients to the DVA FHIR Servers over mTLS.

## Functionality
- Forward requests from the clients to DVA FHIR Servers over mTLS 
- Enforce mTLS connections
- Facilitate OAuth2.0 authorization code flow

## OpenAPI
https://dvp-proxy.test.mgo.irealisatie.nl/docs

## Who uses this service?
- IOS app
- Android app
- Web app

## Keys/Secrets

### mTLS

### signing
supports multiple keys:
    public_signing_key (signing.public_key_paths)
    The public key for the private key used to sign the dataservice endpoints
    
### OAuth2.0
state_signing_key (oauth2.state_signing_key_path)
Used to sign the state parameter in the OAuth2.0 authorization code flow.

## Repository 
https://github.com/minvws/nl-mgo-dvp-proxy-private
