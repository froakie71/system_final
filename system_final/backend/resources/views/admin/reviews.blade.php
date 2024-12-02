<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Hotel Reviews - Admin Dashboard</title>
    <link href="https://cdn.tailwindcss.com" rel="stylesheet">
</head>
<body class="bg-gray-100">
    <div class="container mx-auto px-4 py-8">
        <div class="bg-white rounded-lg shadow-lg p-6">
            <h1 class="text-2xl font-bold mb-6">Hotel Reviews</h1>
            
            <div class="mb-6">
                <input type="text" 
                       id="search" 
                       placeholder="Search reviews..." 
                       class="w-full px-4 py-2 border rounded-lg">
            </div>

            <div class="overflow-x-auto">
                <table class="min-w-full table-auto">
                    <thead>
                        <tr class="bg-gray-100">
                            <th class="px-4 py-2">Hotel</th>
                            <th class="px-4 py-2">Rating</th>
                            <th class="px-4 py-2">Feedback</th>
                            <th class="px-4 py-2">User</th>
                            <th class="px-4 py-2">Date</th>
                        </tr>
                    </thead>
                    <tbody id="reviewsTable">
                        <!-- Reviews will be loaded here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script>
        function loadReviews(search = '') {
            fetch(`/api/reviews?search=${search}`)
                .then(response => response.json())
                .then(data => {
                    const tbody = document.getElementById('reviewsTable');
                    tbody.innerHTML = '';
                    
                    data.data.forEach(review => {
                        tbody.innerHTML += `
                            <tr class="border-b">
                                <td class="px-4 py-2">${review.hotel_name}</td>
                                <td class="px-4 py-2">${'⭐'.repeat(review.rating)}</td>
                                <td class="px-4 py-2">${review.feedback_message}</td>
                                <td class="px-4 py-2">${review.user.name}</td>
                                <td class="px-4 py-2">${new Date(review.created_at).toLocaleDateString()}</td>
                            </tr>
                        `;
                    });
                });
        }

        document.getElementById('search').addEventListener('input', (e) => {
            loadReviews(e.target.value);
        });

        // Initial load
        loadReviews();
    </script>
</body>
</html> 