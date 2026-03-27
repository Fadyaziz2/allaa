<?php

namespace App\Helpers\Core\Traits;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use PhpOffice\PhpSpreadsheet\Exception;
use PhpOffice\PhpSpreadsheet\Writer\Xlsx;

trait ImportFailedTrait
{
    /**
     * @throws Exception
     * @throws \PhpOffice\PhpSpreadsheet\Writer\Exception
     * @throws \PhpOffice\PhpSpreadsheet\Reader\Exception
     */
    public function importFailed($file, $failures): array
    {
        $rowsData = [];
        $rowIndexes = [];
        $errors = [];
        $colCount = count($failures[0]->values());
        foreach ($failures as $failure) {
            if (!in_array($failure->row(), $rowIndexes)) {
                $rowIndexes[] = $failure->row();
                $rowsData[] = collect($failure->values())->values()->toArray();
            }
            //row index
            $rowIndex = $failure->row(); // row that went wrong
            //column index

            $failure->attribute(); // either heading key (if using heading row concern) or column index
            // error message
            $comment = $failure->errors(); // Actual error messages from Laravel validator
            $columnIndex = array_search($failure->attribute(), collect($failure->values())->keys()->all());
            $errors[] = [$columnIndex, $rowIndex, $comment]; // The values of the row that has failed.
        }

        $cellStr = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T'];
        // Create a new Spreadsheet object
        // $spreadsheet = new Spreadsheet($file);

        $reader = new \PhpOffice\PhpSpreadsheet\Reader\Csv();

        $spreadsheet = $reader->load($file->getRealPath());
        // Retrieve the current active worksheet
        $sheet = $spreadsheet->getActiveSheet();

        foreach ($errors as $error) {
            $cell = $cellStr[$error[0]] . $error[1];
            $sheet
                ->getComment($cell)
                ->getText()
                ->createTextRun($error[2]);
            $styleArray = [
                'borders' => [
                    'outline' => [
                        'borderStyle' => \PhpOffice\PhpSpreadsheet\Style\Border::BORDER_THIN,
                        'color' => ['argb' => 'FFFF0000'],
                    ],
                ],
            ];
            $sheet->getStyle($cell)->applyFromArray($styleArray);
        }
        $successfulRows = 0;
        // remove successful data row
        for ($i = $sheet->getHighestDataRow(); $i > 1; --$i) {
            if (!in_array($i, $rowIndexes)) {
                $sheet->removeRow($i, 1);
                $successfulRows++;
            }
        }

        // Write a new .csv file
        $writer = new Xlsx($spreadsheet);

        // If error file exist delete first
//        $checkExistFile = Storage::get("public/import_products.xlsx");
//        if ($checkExistFile) {
//            Storage::delete($checkExistFile);
//        }
        // Save the new .xlsx file
        $errorFileName = Str::slug($file->getClientOriginalName(), '_').'_'.time();
        $pathToFile = storage_path("/app/public/{$errorFileName}.xlsx");
        $writer->save($pathToFile);

        return [
            'success_count' => $successfulRows,
            'success_rate' => round(($successfulRows / ($successfulRows + count($rowIndexes))) * 100),
            'failed_count' => count($rowIndexes),
            'failed_rate' => round((count($rowIndexes) / ($successfulRows + count($rowIndexes))) * 100),
            'error_count' => $failures->count(),
            'error_rate' => round(($failures->count() / ($colCount * count($rowIndexes))) * 100),
            'path_to_file' => 'storage/'.$errorFileName.'.xlsx'
        ];
    }
}
