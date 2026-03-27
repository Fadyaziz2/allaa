<?php

namespace Database\Seeders\Invoice\Note;

use App\Models\Invoice\Note\Note;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class NoteSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Note::query()->truncate();
        Note::query()->insert([
            [
                'name' => 'Invoice',
                'note' => 'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available',
                'type' => 'invoice'
            ],
            [
                'name' => 'Quotation',
                'note' => 'In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum may be used as a placeholder before final copy is available',
                'type' => 'estimate'
            ],
        ]);
    }
}
