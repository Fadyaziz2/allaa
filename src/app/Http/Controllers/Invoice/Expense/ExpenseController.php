<?php

namespace App\Http\Controllers\Invoice\Expense;

use App\Exceptions\GeneralException;
use App\Filters\Invoice\Expense\ExpenseFilter;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Traits\FileHandler;
use App\Http\Requests\Invoice\Expense\ExpenseRequest;
use App\Models\Core\File\File;
use App\Models\Invoice\Expense\Expense;
use Illuminate\Support\Facades\DB;

class ExpenseController extends Controller
{
    use FileHandler;

    public function __construct(ExpenseFilter $filter)
    {
        $this->filter = $filter;
    }

    public function index()
    {
        return Expense::query()
            ->filter($this->filter)
            ->with('category:id,name', 'attachments')
            ->orderBy('id', request()->get('orderBy', 'desc'))
            ->paginate(request()->get('per_page', 10));
    }


    /**
     * @throws GeneralException
     */
    public function store(ExpenseRequest $request)
    {
        try {
            DB::beginTransaction();
            $expense = Expense::query()->create($request->all());
            $this->expenseAttachments($request, $expense);
            DB::commit();
            return created_responses('expense');
        } catch (\Exception $e) {
            DB::rollBack();
            throw new GeneralException(__('default.expense_has_been_created_failed'));
        }

    }

    /**
     * Display the specified resource.
     */
    public function show(Expense $expense): Expense
    {
        return $expense->load('attachments:id,path,imageable_id');
    }

    /**
     * Update the specified resource in storage.
     * @throws GeneralException
     */
    public function update(ExpenseRequest $request, Expense $expense)
    {
        try {
            DB::beginTransaction();
            $expense->update($request->all());
            $this->expenseAttachments($request, $expense);
            $this->removeAttachment($request);

            DB::commit();
            return updated_responses('expense');
        } catch (\Exception $e) {
            DB::rollBack();
            throw new GeneralException(__('default.expense_has_been_updated_failed'));
        }

    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Expense $expense)
    {
        $expense->delete();

        return deleted_responses('expense');
    }

    private function expenseAttachments(ExpenseRequest $request, \Illuminate\Database\Eloquent\Model|\Illuminate\Database\Eloquent\Builder $expense): void
    {

        if ($request->file('attachments')) {
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
        if ($request->deletable_attachment_ids) {
            $deletableAttachments = File::query()->whereIn('id', $request->deletable_attachment_ids)->get();
            $paths = [];
            foreach ($deletableAttachments as $deletableAttachment) {
                $paths[] = $deletableAttachment->path;
            }
            $deleted = File::query()->whereIn('id', $request->deletable_attachment_ids)->delete();
            if ($deleted) {
                $this->deleteMultipleFile($paths);
            }
        }
    }
}
