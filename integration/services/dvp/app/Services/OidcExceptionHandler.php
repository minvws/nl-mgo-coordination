<?php

declare(strict_types=1);

namespace App\Services;

use Exception;
use Jumbojett\OpenIDConnectClientException;
use MinVWS\OpenIDConnectLaravel\Services\ExceptionHandler;
use Symfony\Component\HttpFoundation\Response;

class OidcExceptionHandler extends ExceptionHandler
{
    /**
     * Called when url contains query parameter error.
     * For example user is sent back from idp with error=login_cancelled.
     * @param OpenIDConnectClientException $exception
     * @return Response
     */
    protected function handleRequestError(OpenIDConnectClientException $exception): Response
    {
        $error = $this->getErrorParamFromRequest();
        switch ($error) {
            // If authentication flow cancelled from uzi pilot
            // If authentication flow cancelled from chosen authentication provider
            case 'login_required':
                return redirect()
                    ->route('login')
                    ->with('error', __('Login cancelled'));
        }

        return $this->default400Response($exception);
    }

    /**
     * Called when url contains query parameter code and state, and state does not match with the value from session.
     * @param OpenIDConnectClientException $exception
     * @return Response
     */
    protected function handleUnableToDetermineState(OpenIDConnectClientException $exception): Response
    {
        return redirect()
            ->route('login')
            ->with('error', __('Something went wrong with logging in, please try again.'));
    }

    protected function defaultResponse(OpenIDConnectClientException $exception): Response
    {
        return redirect()
            ->route('login')
            ->with('error', __('Something went wrong with logging in, please try again.'));
    }

    protected function defaultResponseGenericException(Exception $exception): Response
    {
        return redirect()
            ->route('login')
            ->with('error', __('Something went wrong with logging in, please try again.'));
    }

    protected function default400Response(OpenIDConnectClientException $exception): Response
    {
        return redirect()
            ->route('login')
            ->with('error', __('Something went wrong with logging in, please try again.'));
    }

    protected function getErrorParamFromRequest(): ?string
    {
        $request = request();

        $error = $request->query('error');
        if (!is_string($error)) {
            return null;
        }

        return $error;
    }
}
