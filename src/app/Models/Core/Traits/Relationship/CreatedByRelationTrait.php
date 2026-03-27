<?php

namespace App\Models\Core\Traits\Relationship;

use App\Models\User;

trait CreatedByRelationTrait
{
    public function createdBy(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by', 'id');
    }
}
