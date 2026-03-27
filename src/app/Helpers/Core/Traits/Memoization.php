<?php

namespace App\Helpers\Core\Traits;

trait Memoization
{
    protected static array $memoized = [];

    /**
     * Memoize Operation Result
     * @param $key
     * @param \Closure $callback
     * @param bool $refresh
     * @return mixed
     */
    public function memoize($key, \Closure $callback, bool $refresh = false): mixed
    {
        if (!isset(static::$memoized[$key]) || $refresh) {
            return static::$memoized[$key] = $callback();
        }
        return static::$memoized[$key];
    }
}
