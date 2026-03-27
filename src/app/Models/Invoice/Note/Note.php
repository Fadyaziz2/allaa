<?php

namespace App\Models\Invoice\Note;

use App\Models\Core\BaseModel;


class Note extends BaseModel
{

    protected $fillable = ['type', 'name', 'note'];
}
