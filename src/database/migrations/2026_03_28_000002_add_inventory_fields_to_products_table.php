<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->double('opening_quantity', 16, 2)->default(0)->after('price');
            $table->double('current_quantity', 16, 2)->default(0)->after('opening_quantity');
            $table->double('alert_quantity', 16, 2)->default(0)->after('current_quantity');
            $table->double('last_purchase_price', 16, 2)->nullable()->after('alert_quantity');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropColumn([
                'opening_quantity',
                'current_quantity',
                'alert_quantity',
                'last_purchase_price',
            ]);
        });
    }
};
