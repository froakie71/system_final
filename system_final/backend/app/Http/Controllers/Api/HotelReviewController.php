<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\HotelReview;
use Illuminate\Http\Request;

class HotelReviewController extends Controller
{
    public function store(Request $request)
    {
        try {
            $request->validate([
                'hotel_name' => 'required|string',
                'feedback_message' => 'required|string',
                'rating' => 'required|integer|min:1|max:5',
                'admin_id' => 'required|exists:users,id'
            ]);

            $review = HotelReview::create([
                'user_id' => auth()->id(),
                'hotel_name' => $request->hotel_name,
                'feedback_message' => $request->feedback_message,
                'rating' => $request->rating,
                'admin_id' => $request->admin_id
            ]);

            return response()->json(['message' => 'Review submitted successfully', 'data' => $review], 201);
        } catch (\Exception $e) {
            \Log::error('Review submission error: ' . $e->getMessage());
            return response()->json(['message' => 'Failed to submit review: ' . $e->getMessage()], 500);
        }
    }

    public function index(Request $request)
    {
        $query = HotelReview::with('user');

        if ($request->search) {
            $query->where(function($q) use ($request) {
                $q->where('hotel_name', 'like', "%{$request->search}%")
                  ->orWhere('feedback_message', 'like', "%{$request->search}%")
                  ->orWhereHas('user', function($q) use ($request) {
                      $q->where('name', 'like', "%{$request->search}%");
                  });
            });
        }

        if ($request->rating) {
            $query->where('rating', $request->rating);
        }

        return response()->json($query->latest()->paginate(10));
    }
} 