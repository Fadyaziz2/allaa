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
        Schema::create('estimate_details', function (Blueprint $table) {
            $table->id();
            $table->double('quantity');
            $table->double('price', 16, 2);
            $table->foreignId('estimate_id')->constrained()->cascadeOnDelete();
            $table->foreignId('product_id')->constrained();
            $table->timestamps();

            $table->index(['product_id', 'estimate_id'], 'estimate_details_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('estimate_details');
    }
};
