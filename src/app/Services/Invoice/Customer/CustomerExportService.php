<?php

namespace App\Services\Invoice\Customer;

use App\Models\User;
use App\Services\Invoice\AppService;
use Maatwebsite\Excel\Facades\Excel;

class CustomerExportService extends AppService
{
    public function __construct(User $user)
    {
        $this->model = $user;
    }

    public function downloadCustomer($batch = 0): \Symfony\Component\HttpFoundation\BinaryFileResponse
    {

        $exportCount = config('excel.exports.chunk_size');
        $skip = ($exportCount * $batch) - $exportCount;
        $data = $this->mapper();

        $customers = $this->getChunk($skip, $exportCount, $this->model, $data, []);


        $title = 'Customer Export';

        return Excel::download(export_builder(
            $customers,
            $this->getHeadings(),
            $title
        ), "$title-$batch.xlsx"
        );
    }

    private function getHeadings(): array
    {
        return [
            'First Name',
            'Last Name',
            'Email',
        ];
    }

    private function mapper(): \Closure
    {
        return fn($customer) => [
            'first_name' => $customer->first_name,
            'last_name' => $customer->last_name,
            'email' => $customer->email,
        ];
    }

    private function getChunk($skip, $take, $model, $map, array $relation = null)
    {
        return $model::with($relation)
            ->whereHas('roles', fn($q) => $q->where('alias', 'customer'))
            ->skip($skip)
            ->when($take, fn($model) => $model->take($take))
            ->get()
            ->map($map);
    }


}
