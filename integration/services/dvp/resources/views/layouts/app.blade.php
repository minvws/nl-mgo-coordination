<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'My Laravel App')</title>
    @vite('resources/css/app.css')
</head>
<body class="bg-gray-100">
    <header class="bg-indigo-600 text-white py-4">
        <div class="container mx-auto">
            <h1 class="text-2xl font-bold">
                <a href="/" class="hover:text-gray-200">Vertrouwde AuthenticatieDienst poc</a>
            </h1>
        </div>
    </header>

    <main class="container mx-auto p-6">
        @yield('content')
    </main>

    <footer class="bg-gray-800 text-white py-4 mt-10">
        <div class="container mx-auto text-center">
            <p>Vertrouwde AuthenticatieDienst poc</p>
        </div>
    </footer>
</body>
</html>
