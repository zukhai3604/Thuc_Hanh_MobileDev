<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;

class CategoryController extends Controller
{
    public function index()  { return Category::all(); }
    public function store(Request $r)
    {
        $data = $r->validate(['name' => 'required|string|max:255|unique:categories,name']);
        return response()->json(Category::create($data), 201);
    }
    public function show(Category $category)   { return $category; }
    public function update(Request $r, Category $category)
    {
        $data = $r->validate(['name' => 'required|string|max:255|unique:categories,name,'.$category->id]);
        $category->update($data);
        return response()->json($category, 200);
    }
    public function destroy(Category $category)
    {
        $category->delete();
        return response()->json(null, 204);
    }
}
