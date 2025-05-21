@extends('layouts.app')

@section('title', 'Login')

@section('content')
<div class="w-full max-w-md bg-white shadow-lg rounded-lg p-8 mx-auto mt-10">
    <h2 class="text-2xl font-bold text-center mb-6">Login</h2>
    <form method="GET" action="{{ route('oidc.login') }}">
        @csrf
        <div class="flex items-center justify-between">
            <button type="submit" class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-500">
                Login met Vertrouwde Authenticatiedienst
            </button>
        </div>
    </form>
</div>
@endsection
