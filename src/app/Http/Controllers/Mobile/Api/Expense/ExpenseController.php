<?php

namespace App\Http\Controllers\Mobile\Api\Expense;

use App\Exceptions\GeneralException;
use App\Filters\Invoice\Expense\ExpenseFilter;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Traits\FileHandler;
use App\Http\Requests\Invoice\Expense\ExpenseRequest;
use App\Http\Resources\Mobile\Expense\ExpenseResourceCollection;
use App\Http\Resources\Mobile\Expense\ExpenseShowResource;
use App\Models\Core\File\File;
use App\Models\Invoice\Expense\Expense;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class ExpenseController extends Controller
{
    use FileHandler;

    public function __construct(ExpenseFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        $expenses = Expense::query()
            ->filter($this->filter)
            ->with('category:id,name')
            ->select(['id', 'title', 'date', 'amount', 'category_id'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new ExpenseResourceCollection($expenses));
    }


    public function store(ExpenseRequest $request): \Illuminate\Http\JsonResponse
    {
        try {
            DB::beginTransaction();
            $expense = Expense::query()->create($request->all());
            $this->expenseAttachments($request, $expense);
            DB::commit();
            return success_response('Expense created successfully');
        } catch (\Exception $e) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response('Expense has been created failed', 500);
            }
            return error_response($e->getMessage(), 500);

        }
    }

    /**
     * Display the specified resource.
     */
    public function show(Expense $expense): \Illuminate\Http\JsonResponse
    {
        $showExpense = $expense->load('attachments');
        return success_response('Data fetched successfully', new ExpenseShowResource($showExpense));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(ExpenseRequest $request, Expense $expense)
    {
        try {
            DB::beginTransaction();
            $expense->update($request->only('title',
                'date',
                'reference',
                'amount',
                'category_id',
                'note'));
            $this->expenseAttachments($request, $expense);
            $this->removeAttachment($request);
            DB::commit();
            return updated_responses('expense');
        } catch (\Exception $e) {
            DB::rollBack();
            if (app()->environment('production')) {
                return error_response(__('default.expense_has_been_updated_failed'), 500);
            }
            return error_response($e->getMessage(), 500);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Expense $expense): \Illuminate\Http\JsonResponse
    {
        $expense->delete();
        return success_response('Expense deleted successfully');
    }

    private function expenseAttachments(ExpenseRequest $request, \Illuminate\Database\Eloquent\Model|\Illuminate\Database\Eloquent\Builder $expense): void
    {
        // Handle new attachments
        if ($request->hasFile('attachments')) {
            foreach ($request->file('attachments') as $attachment) {
                $filePath = $this->uploadImage($attachment, 'attachments', null);
                $expense->attachments()->create([
                    'path' => $filePath,
                    'type' => 'image',
                ]);
            }
        }
    }


    private function removeAttachment(ExpenseRequest $request): void
    {
        $removeAttachments = json_decode($request->remove_attachments, true);
        if ($removeAttachments) {
            $deletableAttachments = File::query()->whereIn('id', $removeAttachments)->get();
            $paths = [];
            foreach ($deletableAttachments as $deletableAttachment) {
                $paths[] = $deletableAttachment->path;
            }
            $deleted = File::query()->whereIn('id', $removeAttachments)->delete();
            if ($deleted) {
                $this->deleteMultipleFile($paths);
            }
        }
    }

}
