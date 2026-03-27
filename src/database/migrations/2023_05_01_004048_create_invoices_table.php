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
        Schema::create('invoices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')
                ->constrained('users')
                ->cascadeOnDelete();
            $table->date('issue_date');
            $table->date('due_date');
            $table->unsignedBigInteger('invoice_number')->unique();
            $table->string('invoice_full_number')->unique();
            $table->string('reference_number')->nullable();
            $table->boolean('recurring');
            $table->foreignId('recurring_type_id')->nullable()
                ->constrained('recurring_types')
                ->cascadeOnUpdate()
                ->nullOnDelete();
            $table->foreignId('status_id')->constrained('statuses');
            $table->double('sub_total', 16,2);
            $table->enum('discount_type', ['none', 'fixed', 'percentage'])->default('none');
            $table->double('discount_amount', 16,2)->nullable();
            $table->double('total_amount', 16,2);
            $table->double('grand_total', 16,2);
            $table->double('received_amount', 16,2)->nullable();
            $table->double('due_amount', 16,2);
            $table->text('note')->nullable();
            $table->string('invoice_template');
            $table->foreignId('created_by')->constrained('users');
            $table->timestamps();

            $table->index(['status_id', 'created_by', 'customer_id'], 'invoice_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('invoices');
    }
};
