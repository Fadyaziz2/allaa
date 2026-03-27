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
        Schema::create('transactions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('invoice_number')->unique();
            $table->string('invoice_full_number')->unique();
            $table->foreignId('invoice_id')->constrained();
            $table->foreignId('customer_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('payment_method_id')->constrained('payment_methods');
            $table->date('received_on');
            $table->double('amount', 16,2);
            $table->text('note')->nullable();
            $table->string('token')->nullable();
            $table->foreignId('received_by')->constrained('users');
            $table->timestamps();

            $table->index(['invoice_id', 'payment_method_id', 'received_by'], 'transaction_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transactions');
    }
};
