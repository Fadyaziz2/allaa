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
        Schema::create('expenses', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->date('date');
            $table->string('reference')->nullable();
            $table->double('amount', 16, 2);
            $table->foreignId('category_id')->constrained();
            $table->text('note')->nullable();
            $table->timestamps();
            $table->index(['category_id'], 'expense_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('expenses');
    }
};
