<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use App\Models\FrontendUser;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // Create admin user if not exists
        User::firstOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'Admin User',
                'password' => Hash::make('password'),
                'role' => 'admin',
            ]
        );

        // Create test user if not exists
        User::firstOrCreate(
            ['email' => 'user@example.com'],
            [
                'name' => 'Test User',
                'password' => Hash::make('password'),
                'role' => 'user',
            ]
        );

        // Create frontend user if not exists
        FrontendUser::firstOrCreate(
            ['email' => 'frontend@example.com'],
            [
                'name' => 'Test Frontend User',
                'password' => Hash::make('password'),
            ]
        );
    }
}
