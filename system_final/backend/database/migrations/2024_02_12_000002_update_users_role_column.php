<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

class UpdateUsersRoleColumn extends Migration
{
    public function up()
    {
        // First ensure the role column exists
        if (!Schema::hasColumn('users', 'role')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('role')->default('user');
            });
        }

        // Update existing users to be admins (adjust the IDs as needed)
        DB::table('users')
            ->whereIn('id', [1, 2, 3]) // Add all your admin user IDs here
            ->update(['role' => 'admin']);
    }

    public function down()
    {
        // Revert admin roles if needed
        DB::table('users')
            ->whereIn('id', [1, 2, 3])
            ->update(['role' => 'user']);
    }
} 