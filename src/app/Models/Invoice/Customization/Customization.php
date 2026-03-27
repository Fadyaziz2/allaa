<?php

namespace App\Models\Invoice\Customization;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Customization extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'value', 'type'];

}
