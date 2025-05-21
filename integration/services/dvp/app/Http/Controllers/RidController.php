<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Requests\ExchangeRidRequest;

class RidController extends Controller
{
    public function exchange(ExchangeRidRequest $request){
        if (config('prs.mock_enabled')) {
            return response()->json(
                array_fill(0, $request->input('count'), $request->input('rid')),
            );
        }

        $rid = $request->input('rid');
        $response = Http::post('http://prs:6502/rid/exchange/rid?rid='.$rid.'&count='.$request->input('count'));

        return $response->json();
    }
}
