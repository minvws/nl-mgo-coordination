<?php

declare(strict_types=1);

namespace App\Services;

use Illuminate\Support\Facades\Session;
use MinVWS\OpenIDConnectLaravel\Services\JWE\JweDecryptException;
use MinVWS\OpenIDConnectLaravel\Services\JWE\JweDecryptService as DecryptService;

class JweDecryptService extends DecryptService
{
    /**
     * @throws JweDecryptException
     */
    public function decrypt(string $jweString): string
    {
        $payload = parent::decrypt($jweString);

        // Set the payload in the session so we can use it later
        Session::put('oidc_jwt', $payload);

        return $payload;
    }
}
