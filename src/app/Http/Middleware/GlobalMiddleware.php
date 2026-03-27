<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class GlobalMiddleware
{

    public function handle(Request $request, Closure $next)
    {
        $canAccess = 'no';
        if (auth()->user()->can('manage_global_access')) {
            $canAccess = 'yes';
        }
        $request->merge(['globalRoleAccess' => $canAccess]);

        return $next($request);
    }
}
