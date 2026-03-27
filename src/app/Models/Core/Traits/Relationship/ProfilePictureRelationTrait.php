<?php

namespace App\Models\Core\Traits\Relationship;

use App\Models\Core\File\File;
use Illuminate\Database\Eloquent\Relations\MorphOne;

trait ProfilePictureRelationTrait
{
    public function profilePicture(): MorphOne
    {
        return $this->morphOne(File::class, 'imageable')
            ->where('type', 'profile_picture');
    }
}
