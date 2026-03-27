<?php

namespace App\Models\Core\Traits\Relationship;

use App\Models\Core\Status\Status;

trait StatusRelationTrait
{
    public function status(): \Illuminate\Database\Eloquent\Relations\BelongsTo
    {
        return $this->belongsTo(Status::class, 'status_id', 'id');
    }
}
