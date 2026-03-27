<?php

namespace App\Http\Controllers\Invoice\Note;

use Illuminate\Http\Request;
use App\Models\Invoice\Note\Note;
use App\Http\Controllers\Controller;
use App\Http\Requests\Invoice\Note\NoteRequest;

class NoteController extends Controller
{

    public function index(Request $request)
    {
        return Note::query()
            ->when($request->get('type'), fn ($q) => $q->whereType($request->get('type')))
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));
    }


    public function store(NoteRequest $request)
    {
        Note::query()->create($request->all());

        return created_responses('notes');
    }

    /**
     * Display the specified resource.
     */
    public function show(Note $note)
    {
        return $note;
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(NoteRequest $request, Note $note)
    {
        $note->update($request->all());

        return updated_responses('notes');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Note $note)
    {
        $note->delete();

        return deleted_responses('notes');
    }
}
