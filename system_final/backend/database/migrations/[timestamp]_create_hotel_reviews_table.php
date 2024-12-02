<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('hotel_reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('frontend_users')->onDelete('cascade');
            $table->string('hotel_name');
            $table->text('feedback_message');
            $table->integer('rating');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('hotel_reviews');
    }
}; 