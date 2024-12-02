<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class HotelReview extends Model
{
    protected $fillable = [
        'user_id',
        'hotel_name',
        'feedback_message',
        'rating',
        'admin_id'
    ];

    public function user()
    {
        return $this->belongsTo(FrontendUser::class);
    }
} 