<?php

namespace App\Services\Core\Installer\Update;

use App\Exceptions\GeneralException;
use GuzzleHttp\Client;
use Illuminate\Filesystem\Filesystem;

class UpdateCurlRequestSender
{
    protected Client $client;

    public function __construct(Client $client)
    {
        $this->client = $client;
    }

    public function get($url)
    {
        $request = $this->client->get($url, [
            'verify' => false,
            'curl' => [
                CURLOPT_RETURNTRANSFER => true
            ]
        ]);

        return json_decode($request->getBody()->getContents());
    }

    /**
     * @throws \Throwable
     */
    public function download($result, $code)
    {

        ini_set('memory_limit', '1G');
        set_time_limit(600);


        $separator = DIRECTORY_SEPARATOR;

        if (!is_array($result)) {
            return $result;
        }


        $results = collect((array)$result)->map(function ($version) {
            $version->version = $version->version . '.zip';
            return $version;
        })->toArray();


        $file = new Filesystem();

        if (!$file->isDirectory(public_path('updates'))) {
            $file->makeDirectory(public_path('updates'));
        }

        $downloaded_updates = $file->allFiles(public_path('updates' . $separator));
        //start from here
        $pending_download_list = $result;

        foreach ($downloaded_updates as $filePath) {
            $saved_version = substr($filePath, strrpos(public_path('updates' . $separator), $separator) + 1, strlen($filePath) - 1);
            $spliceIndex = array_search($saved_version, array_column($results, 'version'));
            if ($spliceIndex) {
                unset($pending_download_list[$spliceIndex]);
            }
        }

        throw_if(
            !(is_array($pending_download_list) && count($pending_download_list)),
            new GeneralException('No new update found', 404)
        );

        foreach ($pending_download_list as $download) {
            $applicationDetails = config('theme29');
            $url = config('theme29.marketplace_url') . '/update/download/' . $applicationDetails['app_id'] . '/' . str_replace('.zip', '', $download->version) . '?domain_name=' . request()->getHost() . '&purchase_key=' . $code . '&app_version=' . $applicationDetails['app_version'];


            $destination = public_path('updates' . $separator);


            $filePath = fopen($destination . str_replace('.zip', '', $download->version) . '.zip', 'w+');
            $ch = curl_init($url);
            curl_setopt($ch, CURLOPT_TIMEOUT, 1050);
            curl_setopt($ch, CURLOPT_FILE, $filePath);
            curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
            curl_exec($ch);
            curl_close($ch);
            fclose($filePath);
        }
    }


    /**
     * @throws \Throwable
     */
    public function validatePHPVersion(): void
    {
        $checkPhpVersion = config('installer.core.minPhpVersion');

        throw_if(
            phpversion() <= $checkPhpVersion,
            new GeneralException(trans('default.please_update_your_php_version_to_number', ['number' => $checkPhpVersion]), 404)
        );
    }
}
