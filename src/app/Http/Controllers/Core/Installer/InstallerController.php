<?php

namespace App\Http\Controllers\Core\Installer;

use App\Helpers\Core\Installer\AdditionalRequirementHelper;
use App\Helpers\Core\Installer\PermissionHelper;
use App\Helpers\Core\Installer\RequirementsHelper;
use App\Http\Controllers\Controller;

class InstallerController extends Controller
{
    protected RequirementsHelper $requirements;
    protected PermissionHelper $permission;
    protected AdditionalRequirementHelper $additionalRequirement;

    public function __construct(RequirementsHelper $requirements, PermissionHelper $permission, AdditionalRequirementHelper $additionalRequirement)
    {
        $this->requirements = $requirements;
        $this->permission = $permission;
        $this->additionalRequirement = $additionalRequirement;

    }

    public function index()
    {
        $checkPhpVersion = $this->requirements->checkPHPVersion(
            config('installer.core.minPhpVersion')
        );
        $checkMysqlVersion = $this->requirements->checkMysqlVersion(
            config('installer.core.minMysqlVersion')
        );

        $requirements = $this->requirements->checkRequirement(
            config('installer.requirements')
        );

        $permissions = $this->permission->check(
            config('installer.permissions'));

        $additionalRequirement = $this->additionalRequirement->index();



        return [
            'checkPhpVersion' => $checkPhpVersion,
            'mysqlVersion' => $checkMysqlVersion,
            'requirements' => $requirements,
            'permissions' => $permissions,
            'additional_requirement' => $additionalRequirement
        ];
    }
}
