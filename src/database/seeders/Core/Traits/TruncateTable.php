<?php


namespace Database\Seeders\Core\Traits;

use Illuminate\Support\Facades\DB;

trait TruncateTable
{
    /**
     * @param $table
     * @khokon ahmed
     *
     * @return bool | mixed
     */
    protected function truncate($table): mixed
    {
        return match (DB::getDriverName()) {
            'mysql' => DB::table($table)->truncate(),
            'pgsql' => DB::statement('TRUNCATE TABLE ' . $table . ' RESTART IDENTITY CASCADE'),
            'sqlite', 'sqlsrv' => DB::statement('DELETE FROM ' . $table),
            default => false,
        };

    }

    /**
     * @param array $tables
     */
    protected function truncateMultiple(array $tables): void
    {
        foreach ($tables as $table) {
            $this->truncate($table);
        }
    }
}
