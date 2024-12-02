<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Home - Feedback Management System</title>
    <link rel="preconnect" href="https://fonts.bunny.net">
    <link href="https://fonts.bunny.net/css?family=figtree:400,500,600&display=swap" rel="stylesheet" />
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
    <!-- Navigation Bar -->
    <nav class="bg-white shadow-lg">
        <div class="max-w-6xl mx-auto px-4">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center">
                    <span class="text-xl font-semibold text-gray-800">Feedback Management System</span>
                </div>
                <div class="flex items-center space-x-4">
                    <span class="text-gray-700">Welcome, {{ Auth::user()->name }}</span>
                    <form method="POST" action="{{ route('logout') }}" class="inline">
                        @csrf
                        <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded-md hover:bg-red-600">
                            Logout
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="max-w-6xl mx-auto px-4 py-8">
        <!-- Dashboard Stats -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="text-gray-600 text-sm font-medium">Total Feedback</h3>
                <p class="text-2xl font-bold text-gray-800">0</p>
            </div>
            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="text-gray-600 text-sm font-medium">Pending Responses</h3>
                <p class="text-2xl font-bold text-gray-800">0</p>
            </div>
            <div class="bg-white rounded-lg shadow p-6">
                <h3 class="text-gray-600 text-sm font-medium">Resolved Feedback</h3>
                <p class="text-2xl font-bold text-gray-800">0</p>
            </div>
        </div>

        <!-- Feedback Section -->
        <div class="bg-white rounded-lg shadow">
            <div class="p-6 border-b border-gray-200">
                <div class="flex justify-between items-center">
                    <h2 class="text-xl font-semibold text-gray-800">Recent Feedback</h2>
                    <button class="bg-indigo-600 text-white px-4 py-2 rounded-md hover:bg-indigo-700">
                        Add New Feedback
                    </button>
                </div>
            </div>
            
            <!-- Feedback List -->
            <div class="p-6">
                <!-- Empty State -->
                <div class="text-center py-8">
                    <svg class="mx-auto h-12 w-12 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 13V6a2 2 0 00-2-2H6a2 2 0 00-2 2v7m16 0v5a2 2 0 01-2 2H6a2 2 0 01-2-2v-5m16 0h-2.586a1 1 0 00-.707.293l-2.414 2.414a1 1 0 01-.707.293h-3.172a1 1 0 01-.707-.293l-2.414-2.414A1 1 0 006.586 13H4"></path>
                    </svg>
                    <h3 class="mt-2 text-sm font-medium text-gray-900">No feedback yet</h3>
                    <p class="mt-1 text-sm text-gray-500">Get started by creating a new feedback.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-white shadow-lg mt-8">
        <div class="max-w-6xl mx-auto px-4 py-4">
            <p class="text-center text-gray-600 text-sm">
                © 2024 Feedback Management System. All rights reserved.
            </p>
        </div>
    </footer>
</body>
</html>
