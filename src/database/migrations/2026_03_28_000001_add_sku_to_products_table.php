<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->string('sku', 50)->nullable()->after('code');
        });

        $usedSku = [];

        DB::table('products')
            ->select(['id', 'code'])
            ->orderBy('id')
            ->get()
            ->each(function ($product) use (&$usedSku) {
                $baseSku = $product->code ?: 'SKU-' . strtoupper(Str::random(8));
                $sku = $baseSku;
                $counter = 1;

                while (isset($usedSku[$sku])) {
                    $suffix = '-' . $counter;
                    $sku = Str::limit($baseSku, 50 - strlen($suffix), '') . $suffix;
                    $counter++;
                }

                $usedSku[$sku] = true;

                DB::table('products')->where('id', $product->id)->update(['sku' => $sku]);
            });

        Schema::table('products', function (Blueprint $table) {
            $table->unique('sku', 'products_sku_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('products', function (Blueprint $table) {
            $table->dropUnique('products_sku_unique');
            $table->dropColumn('sku');
        });
    }
};
