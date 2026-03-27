<?php

namespace App\Http\Controllers\Core\Lang;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\App;
use Illuminate\Support\Facades\Lang;

class LanguageController extends Controller
{
  public function index(string $locale)
  {

      // Set the app locale
      App::setLocale($locale);

      // Save the locale in a cookie (for 30 days)
      $cookie = cookie('locale', $locale, 60 * 24 * 30); // 30 days
      $translations = Lang::get('default');

      return response()->json([
          "locale" => App::currentLocale(),
          "languages" => $translations
      ])->withCookie($cookie);


  }
}
