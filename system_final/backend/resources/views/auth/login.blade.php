<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">    
    <title>Login - Feedback Management System</title>
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <div class="min-h-screen flex items-center justify-center">
        <div class="bg-white p-8 rounded-lg shadow-md w-full max-w-md mx-4">
            <h1 class="text-2xl font-bold text-center text-gray-800 mb-8">Feedback Management System</h1>
            
            <form class="space-y-6" method="POST" action="{{ route('login') }}">
                @csrf
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Email</label>
                    <input 
                        type="email"
                        name="email" 
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        placeholder="Enter your email"
                        required
                    >
                </div>

                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Password</label>
                    <input 
                        type="password"
                        name="password" 
                        class="w-full px-4 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500"
                        placeholder="Enter your password"
                        required
                    >
                </div>

                @error('email')
                    <p class="text-red-500 text-sm">{{ $message }}</p>
                @enderror

                <button type="submit" class="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700">
                    Login
                </button>
            </form>

            <p class="mt-4 text-center text-sm text-gray-600">
                Don't have an account? 
                <a href="/register" class="font-medium text-indigo-600 hover:text-indigo-500">Sign up</a>
            </p>
        </div>
    </div>
</body>
</html>
