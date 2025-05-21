@extends('layouts.app')

@section('title', 'User Profile')

@section('content')
<div class="bg-white shadow-md rounded-lg p-6 max-w-2xl mx-auto mt-10">
    <h2 class="text-3xl font-bold mb-4">User Profile</h2>
    <div class="mb-4">
        <div class="my-4">
            <label for="full_name" class="block text-sm font-medium text-gray-700">Full name from BRP:</label>
            <input type="text" id="full_name" name="full_name" disabled value="{{ Auth::user()->full_name }}"
                   class="mt-1 block w-full px-3 py-2 disabled text-gray-500 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            <small class="text-gray-500">This value is retrieved from the "BasisRegistratie Persoonsgegevens" based on the users BSN</small>
        </div>
    </div>

    <div class="mb-4">
        <div class="my-4">
            <label for="Age" class="block text-sm font-medium text-gray-700">Age received from BRP:</label>
            <input type="text" id="Age" name="Age" disabled value="{{ Auth::user()->age }}"
                   class="mt-1 block w-full px-3 py-2 disabled text-gray-500 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            <small class="text-gray-500">This value is retrieved from the "BasisRegistratie Persoonsgegevens" based on the users BSN</small>
        </div>
    </div>

    <div class="mb-4">
        <div class="my-4">
            <label for="PDN" class="block text-sm font-medium text-gray-700">Organisation specific pseudonym:</label>
            <input type="text" id="PDN" name="PDN" disabled value="{{ Auth::user()->reference_pseudonym }}"
                   class="mt-1 block w-full px-3 py-2 disabled text-gray-500 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            <small class="text-gray-500">This value is deterministic and should not change</small>
        </div>
    </div>

    <div class="text-xl mb-2">Request additional data</div>
        <p class="my-2">Using this form, additional user information can be requested at a "Dienstverlener Aanbieder", which typically contains sensitive data about a user, which should only be visible to logged in users.</p>
        <p>The RID in this form is the latest RID that was received for this user. The DVA which is authorized to work with BSN's, can exchange this RID for the actual BSN so it can look up the user's data.</p>
        @csrf

        <div class="my-4">
            <label for="rid" class="block text-sm font-medium text-gray-700">RID:</label>
            <input type="text" id="rid" name="rid" required value="{{ Auth::user()->rids()->get()->last()->rid }}"
                   class="mt-1 block w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
        </div>

        <div class="flex justify-end">
            <button type="submit" id="submitButton"
                    class="bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Submit
            </button>
        </div>

        <div id="responseContainer"></div>

    <div class="mb-2">
        <div class="text-lg">
            <p>Refresh RID</p>
        </div>

        <p>Click the button below to refresh the RID for this user. This will generate new RID's for this user, which can be used to request additional data from a Dienstverlener Aanbieder.</p>
        <div class="flex gap-4">
            <input type="number" id="count" name="count" value="5" class="mt-1 block w-1/6 px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500">
            <button type="submit" id="refreshRID"
                    class="bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                Refresh RID
            </button>
        </div>


        <ol type="1" id="ridsContainer" class="list-decimal pl-5 overflow-scroll text-nowrap">
        </ol>
    </div>

    <form action="{{ route('logout') }}" method="post">
        @csrf
        <button type="submit" class="mt-4 bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">Logout</button>
    </form>

    <script>
        document.getElementById('submitButton').addEventListener('click', function() {
            const url = 'http://localhost:8001/patient';
            const data = new URLSearchParams({
                rid: document.getElementById('rid').value
            });

            fetch(url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: data.toString()
            })
            .then(response => response.json())
            .then(json => {
                const responseContainer = document.getElementById('responseContainer');
                responseContainer.innerHTML = `<pre>${JSON.stringify(json, null, 2)}</pre>`;
            })
            .catch(error => {
                console.error('Error:', error);
                const responseContainer = document.getElementById('responseContainer');
                responseContainer.textContent = 'Er is een fout opgetreden!';
        });
    });

    document.getElementById('refreshRID').addEventListener('click', function() {
        const url = '/rid/exchange';
        const data = new URLSearchParams({
            rid: document.getElementById('rid').value,
            count: document.getElementById('count').value,
            _token: document.querySelector('input[name="_token"]').value
        });

        fetch(url, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: data.toString()
        })
        .then(response => response.json())
        .then(json => {
            const ridsContainer = document.getElementById('ridsContainer');
            ridsContainer.innerHTML = '';
            json.forEach(rid => {
                const li = document.createElement('li');
                li.textContent = rid;
                li.classList.add('cursor-pointer', 'hover:underline');
                li.addEventListener('click', function() {
                    document.getElementById('rid').value = rid;
                });
                ridsContainer.appendChild(li);
            });
        })
        .catch(error => {
            console.error('Error:', error);
            const ridsContainer = document.getElementById('ridsContainer');
            ridsContainer.textContent = 'Er is een fout opgetreden!';
        });
    });
    </script>
</div>
@endsection
