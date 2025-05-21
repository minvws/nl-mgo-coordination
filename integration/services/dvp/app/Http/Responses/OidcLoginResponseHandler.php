<?php

declare(strict_types=1);

namespace App\Http\Responses;

use App\Models\User;
use Faker\Generator;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use MinVWS\OpenIDConnectLaravel\Http\Responses\LoginResponseHandlerInterface;
use Symfony\Component\HttpFoundation\Response;

class OidcLoginResponseHandler implements LoginResponseHandlerInterface
{
    public function __construct(private readonly Generator $faker)
    {}

    public function handleLoginResponse(object $userInfo): Response
    {
        $user = User::firstOrCreate([
            'reference_pseudonym' => $userInfo->rid,
        ],
        [
            'name' => $userInfo->person->name->full_name,
            'email' => $this->faker->safeEmail(),
            'password' => bcrypt($this->faker->password()),
            'age' => $userInfo->person->age,
        ]);

        $user->update([
            'full_name'=>$userInfo->person->name->full_name,
            'age' => $userInfo->person->age,
        ]);

        $user->rids()->create([
            'rid'=>$userInfo->rid
        ]);

        Auth::login($user);

        return new RedirectResponse(route('profile'));
    }
}
