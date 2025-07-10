<?php

declare(strict_types=1);

namespace App\Providers;

use App\Http\Responses\OidcLoginResponseHandler;
use App\Services\OidcExceptionHandler;
use MinVWS\OpenIDConnectLaravel\Http\Responses\LoginResponseHandlerInterface;
use MinVWS\OpenIDConnectLaravel\OpenIDConnectServiceProvider;
use MinVWS\OpenIDConnectLaravel\Services\ExceptionHandlerInterface;
use MinVWS\OpenIDConnectLaravel\OpenIDConfiguration\OpenIDConfigurationLoader;
use App\Services\OpenIDConfigurationLoader as VadOpenIDConfigurationLoader;
use Illuminate\Foundation\Application;

class OidcServiceProvider extends OpenIDConnectServiceProvider
{
    protected function registerConfigurationLoader(): void
    {
        $this->app->singleton(OpenIDConfigurationLoader::class, function (Application $app) {
            return new VadOpenIDConfigurationLoader(
                $app['config']->get('oidc.issuer'),
                $app['cache']->store($app['config']->get('oidc.configuration_cache.store')),
                $app['config']->get('oidc.configuration_cache.ttl'),
                $app['config']->get('oidc.tls_verify'),
            );
        });
    }

    protected function registerExceptionHandler(): void
    {
        $this->app->bind(ExceptionHandlerInterface::class, OidcExceptionHandler::class);
    }

    protected function registerResponseHandler(): void
    {
        $this->app->bind(LoginResponseHandlerInterface::class, OidcLoginResponseHandler::class);
    }
}
