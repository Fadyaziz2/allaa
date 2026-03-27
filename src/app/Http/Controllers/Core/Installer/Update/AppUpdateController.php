<?php

namespace App\Http\Controllers\Core\Installer\Update;

use App\Exceptions\GeneralException;
use App\Helpers\Core\Installer\PermissionHelper;
use App\Http\Controllers\Controller;
use App\Services\Core\Installer\Update\UpdateCurlRequestSender;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Http;
use Throwable;

class AppUpdateController extends Controller
{
    protected PermissionHelper $permission;

    protected UpdateCurlRequestSender $updateCurlRequestSender;

    protected UpdateFileManager $updateFileManager;

    public function __construct(PermissionHelper $permission, UpdateCurlRequestSender $updateCurlRequestSender, UpdateFileManager $updateFileManager)
    {
        $this->permission = $permission;
        $this->updateCurlRequestSender = $updateCurlRequestSender;
        $this->updateFileManager = $updateFileManager;
    }


    public function index(): array
    {
        $appVersion = config('theme29.app_version');
        $purchaseCode = env('PURCHASE_CODE');
        $domainName = request()->getHost();
        $config = config('theme29');
        $marketPlaceUrl = "{$config['marketplace_url']}/verification/purchases-code/{$config['app_id']}?domain_name={$domainName}&app_version={$config['app_version']}&purchase_key={$purchaseCode}";
        return [
            'current_app_version' => $appVersion,
            'url' => $marketPlaceUrl
        ];
    }

    /**
     * @throws Throwable
     */
    public function checkUpdate()
    {
        throw_if(
            $this->permission->updateFolderPermissionCheck(['public/' => 'writeable', '/' => 'writeable'])['errors'],
            new GeneralException(trans('default.public_directory_must_be_writeable_to_update_the_app'))
        );


        $updates = $this->updates();


        if ($updates->status) {
            $spliceIndex = array_search(config('theme29.app_version'), array_column((array)$updates, 'version'));
            $result = collect($updates->result)->map(function ($version) {
                $version->version = str_replace('.zip', '', $version->version);
                return $version;
            })->toArray();

            if (!$spliceIndex)
                return response()->json(['status' => true, 'result' => $result]);

            $result = collect($result)->filter(function ($value, $index) use ($spliceIndex) {
                return $index >= $spliceIndex;
            })->toArray();


            return response()->json(['status' => true, 'result' => $result]);

        }
        return response()->json((array)$updates, 402);
    }

    /**
     * @throws Throwable
     */
    public function updates(): object
    {
        if ($code = env('PURCHASE_CODE')) {
            $url = $this->url($code, 'update/list');
            $result = $this->updateCurlRequestSender->get($url)->data;
            $this->updateCurlRequestSender->download($result, $code);
            return (object)['status' => true, 'result' => $result];
        }
        return (object)['status' => false, 'message' => 'Invalid purchase code'];
    }


    /**
     * @throws Throwable
     */
    public function update($version): \Illuminate\Http\JsonResponse
    {
        $this->updateFileManager->removeCachedFile();
        ini_set('memory_limit', '256M');
        set_time_limit(300);
        throw_if(
            !array_search('zip', get_loaded_extensions()),
            new GeneralException(trans('default.install_zip_extension'), 404)
        );

        $nextVersion = $this->getNextReadyToInstallVersion($version);

        throw_if(
            !$nextVersion['check'],
            new GeneralException(trans('default.please_install_version_first', ['number' => $nextVersion['version']]))
        );

        $this->updateFileManager->extract($version);

        if (File::exists(public_path("updates/{$version}.zip"))) {
            File::delete(public_path("updates/{$version}.zip"));
        }

        return response()->json(['status' => true, 'message' => "$version installed successfully."]);
    }

    /**
     * @throws Throwable
     */
    public function getNextReadyToInstallVersion($version): array
    {
        $available_updates = $this->checkUpdate()->getData();


        throw_if(!$available_updates->status, new GeneralException(trans('default.invalid_purchase_code')));

        //$updates = $available_updates->result;

        $updates = $available_updates->result;

        // Sort the updates array by version in ascending order
        usort($updates, function ($a, $b) {
            return version_compare($a->version, $b->version);
        });

        $installable = array_search($version, array_column($updates, 'version'));


        if ($installable === 0)
            return ['version' => $updates[$installable]->version, 'check' => true];

        return ['version' => $updates[0]->version, 'check' => false];
    }

    public function url($code, $type): string
    {
        $domain_name = request()->getHost();
        $config = config('theme29');
        return "{$config['marketplace_url']}/{$type}/{$config['app_id']}?domain_name={$domain_name}&app_version={$config['app_version']}&purchase_key={$code}";
    }


}
