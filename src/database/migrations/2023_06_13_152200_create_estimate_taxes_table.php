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
        Schema::create('estimate_taxes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tax_id')->constrained();
            $table->foreignId('estimate_id')->constrained();
            $table->double('total_amount', 16,2);
            $table->timestamps();
            $table->index(['tax_id', 'estimate_id'], 'estimate_tax_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('estimate_taxes');
    }
};
