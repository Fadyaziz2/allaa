<?php

namespace App\Http\Controllers\Core\Installer;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Http\Requests\Core\Installer\DatabaseManager\DatabaseManagerRequest;
use App\Http\Requests\Core\Setting\EmailSettingRequest;
use App\Services\Core\Installer\DatabaseManagerService;
use App\Services\Core\Setting\EmailSettingService;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\Password;
use Psr\Container\ContainerExceptionInterface;
use Psr\Container\NotFoundExceptionInterface;

class DatabaseManagerController extends Controller
{
    protected EmailSettingService $emailSettingService;

    public function __construct(DatabaseManagerService $service, EmailSettingService $emailSettingService)
    {
        $this->service = $service;
        $this->emailSettingService = $emailSettingService;
    }

    /**
     * @throws ContainerExceptionInterface
     * @throws NotFoundExceptionInterface
     * @throws GeneralException
     */
    public function setConnect(DatabaseManagerRequest $request)
    {

        $this->service
            ->clearCaches()
            ->setDatabaseConnection()
            ->saveFileWizard()
            ->sessionDestroy();

        return response()->json(['status' => true, 'message' => trans('default.database_configured_successfully')]);

    }

    public function userStore(Request $request): \Illuminate\Http\JsonResponse
    {
        $request->validate([
            'first_name' => ['required', 'string', 'max:100'],
            'last_name' => ['required', 'string', 'max:100'],
            'email' => ['required', 'email', 'max:100'],
            'password' => 'required|min:8|regex:/^(?=[^\d]*\d)(?=[A-Z\d ]*[^A-Z\d ]).{8,}$/i',
        ]);

        $this->service
//            ->storageLink()
            ->setMigration()
            ->setDatabaseSeeder()
            ->updateUser();

        return response()->json(['status' => true, 'message' => trans('default.user_info_setup_successfully')]);

    }

    public function update(EmailSettingRequest $request)
    {
        $context = $request->get('provider');

        foreach ($request->only('from_name', 'from_email') as $key => $value) {

            $this->emailSettingService
                ->update($key, $value, 'default_mail_email_name');
        }

        foreach ($request->except('allowed_resource', 'from_name', 'from_email') as $key => $value) {
            $this->emailSettingService
                ->update($key, $value, $context);
        }

        $this->emailSettingService->setDefaultSettings('default_mail', $context);

        $this->service->setEnvironmentValue()
            ->setEnvironmentAppDebugValue();


        return response()->json(['status' => true, 'message' => trans('default.email_setup_successfully')]);

    }

    public function setupSkip(): \Illuminate\Http\JsonResponse
    {
        $this->service->setEnvironmentValue()
            ->setEnvironmentAppDebugValue();

        return response()->json(['status' => true, 'message' => trans('default.email_setup_successfully')]);
    }
}
