<?php

namespace App\Http\Resources\Mobile\Comman\Traits;

use Illuminate\Support\Facades\Storage;

trait ProfilePictureTraitResource
{
    private function customerProfilePicture($path): string
    {
        $system = config('filesystems.default');

        return request()->root() . Storage::disk($system)->url(str_replace('/storage/', '', $path));
    }
}
