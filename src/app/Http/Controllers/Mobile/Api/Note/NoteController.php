<?php

namespace App\Http\Controllers\Mobile\Api\Note;

use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Note\NoteRequest;
use App\Http\Resources\Mobile\Note\NoteResourceCollection;
use App\Models\Invoice\Note\Note;
use Illuminate\Http\Request;

class NoteController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $notes = Note::query()
            ->select(['id', 'note', 'type', 'name'])
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new NoteResourceCollection($notes));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(NoteRequest $request)
    {
        Note::query()->create($request->only('name', 'type', 'note'));

        return success_response('Data created successfully');
    }

    /**
     * Display the specified resource.
     */
    public function show(Note $note): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', $note->makeHidden(['created_at', 'updated_at']));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Note $note): \Illuminate\Http\JsonResponse
    {
        $note->update($request->only('name', 'type', 'note'));
        return success_response('Data updated successfully');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Note $note): \Illuminate\Http\JsonResponse
    {
        $note->delete();

        return success_response('Data deleted successfully');
    }
}
