<?php

namespace App\Services;

use MinVWS\OpenIDConnectLaravel\OpenIDConfiguration\OpenIDConfigurationLoader as BaseOpenIDConfigurationLoader;
use MinVWS\OpenIDConnectLaravel\OpenIDConfiguration\OpenIDConfiguration;

class OpenIDConfigurationLoader extends BaseOpenIDConfigurationLoader
{
    /**
     * @throws OpenIDConfigurationLoaderException
     */
    public function getConfiguration(): OpenIDConfiguration
    {
        $this->cacheStore->flush('openid-configuration');
        return parent::getConfiguration();
    }


    public function getConfigurationFromIssuer(): OpenIDConfiguration
    {
        $config = parent::getConfigurationFromIssuer();

        if(config('oidc.override.authorization_endpoint') !== null) {
            $config->authorizationEndpoint = config('oidc.override.authorization_endpoint');
        }

        if(config('oidc.override.jwks_uri') !== null) {
            $config->jwksUri = config('oidc.override.jwks_uri');
        }

        if(config('oidc.override.token_endpoint') !== null) {
            $config->tokenEndpoint = config('oidc.override.token_endpoint');
        }

        if(config('oidc.override.userinfo_endpoint') !== null) {
            $config->userinfoEndpoint = config('oidc.override.userinfo_endpoint');
        }

        return $config;
    }
}
