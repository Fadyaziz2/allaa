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
        Schema::create('estimates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained('users')->cascadeOnDelete();
            $table->date('date');
            $table->unsignedBigInteger('invoice_number')->unique();
            $table->string('invoice_full_number')->unique();
            $table->foreignId('status_id')->constrained('statuses');
            $table->double('sub_total', 16,2);
            $table->enum('discount_type', ['none', 'fixed', 'percentage'])->default('none');
            $table->double('discount_amount', 16,2)->nullable();
            $table->double('total_amount', 16,2);
            $table->double('grand_total', 16,2);
            $table->text('note')->nullable();
            $table->integer('estimate_template');
            $table->foreignId('created_by')->constrained('users');
            $table->timestamps();

            $table->index(['customer_id', 'created_by'], 'estimate_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('estimates');
    }
};
