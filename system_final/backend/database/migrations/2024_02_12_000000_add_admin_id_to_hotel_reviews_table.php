<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddAdminIdToHotelReviewsTable extends Migration
{
    public function up()
    {
        Schema::table('hotel_reviews', function (Blueprint $table) {
            $table->foreignId('admin_id')
                  ->constrained('users')
                  ->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::table('hotel_reviews', function (Blueprint $table) {
            $table->dropForeign(['admin_id']);
            $table->dropColumn('admin_id');
        });
    }
} 