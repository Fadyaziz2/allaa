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
        Schema::create('notification_template_audiences', function (Blueprint $table) {
            $table->id();
            $table->foreignId('notification_template_id')->constrained('notification_templates');
            $table->string('audience_type');
            $table->text('audience');
            $table->timestamps();
            $table->index(['notification_template_id'], 'notification_template_audiences_index');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notification_template_audiences');
    }
};
