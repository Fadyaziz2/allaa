<?php

namespace App\Http\Controllers\Invoice\Import;

use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Import\ImportRequest;
use App\Imports\ExpenseImport;
use App\Imports\ImportHeadingValidation;
use App\Imports\ProductImport;
use PhpOffice\PhpSpreadsheet\Exception;

class ExpenseImportController extends Controller
{
    use ImportHeadingValidation;

    /**
     * @throws Exception
     * @throws \PhpOffice\PhpSpreadsheet\Writer\Exception
     * @throws \PhpOffice\PhpSpreadsheet\Reader\Exception
     */
    public function import(ImportRequest $request): \Illuminate\Http\JsonResponse|array
    {
        $file = $request->file('files');

        $import = new ExpenseImport();
        $headings = $this->getHeadings($file, $import);
        $missingField = $this->getMissingFields($import, $headings);

        if (!empty($missingField)) {
            return $this->handleMissingFields($missingField);
        }

        $import->import($file);
        $failures = $import->failures();

        if ($failures->count() > 0) {
            $stat = $this->handleImportFailures($file, $failures);
            return $this->partiallyImportedResponse($stat);
        }

        return [
            'status' => 200,
            'message' => trans('default.expense_has_been_imported_successfully')
        ];
    }
}
