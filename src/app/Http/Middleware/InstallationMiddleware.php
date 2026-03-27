<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class InstallationMiddleware
{

    public function handle(Request $request, Closure $next)
    {
        if (config('theme29.purchase_code') && config('theme29.installed')) {
            return $next($request);
        }
        return redirect('/installation');


    }
}
