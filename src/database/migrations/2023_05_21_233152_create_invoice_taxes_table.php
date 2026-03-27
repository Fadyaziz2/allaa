<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('invoice_taxes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('tax_id')->constrained();
            $table->foreignId('invoice_id')->constrained();
            $table->double('total_amount', 16,2);
            $table->timestamps();
            $table->index(['tax_id', 'invoice_id'], 'invoice_tax_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('invoice_taxes');
    }
};
