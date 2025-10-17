<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Validation\Rule;

class ProductController extends Controller
{
    /**
     * Lấy danh sách sản phẩm, có eager loading 'category' và được cache trong 60 giây.
     * GET /api/products
     */
    public function index()
    {
        // Sử dụng Cache::remember để tự động cache kết quả
        return Cache::remember('products', 60, function () {
            return Product::with('category')->orderByDesc('id')->get();
        });
    }

    /**
     * Tạo một sản phẩm mới.
     * POST /api/products
     */
    public function store(Request $request)
    {
        $data = $request->validate([
            'name'        => ['required', 'string', 'max:255', 'unique:products,name'],
            'description' => ['nullable', 'string', 'max:500'],
            'price'       => ['required', 'numeric', 'gte:0'],
            'category_id' => ['nullable', 'exists:categories,id'],
        ]);

        $product = Product::create($data)->load('category');

        // Xóa cache cũ vì dữ liệu đã thay đổi
        Cache::forget('products');

        return response()->json($product, 201);
    }

    /**
     * Lấy thông tin chi tiết của một sản phẩm.
     * GET /api/products/{product}
     */
    public function show(Product $product)
    {
        // Trả về sản phẩm cùng với category của nó
        return $product->load('category');
    }

    /**
     * Cập nhật thông tin của một sản phẩm.
     * PUT/PATCH /api/products/{product}
     */
    public function update(Request $request, Product $product)
    {
        $data = $request->validate([
            'name'        => ['sometimes', 'string', 'max:255', Rule::unique('products', 'name')->ignore($product->id)],
            'description' => ['sometimes', 'nullable', 'string', 'max:500'],
            'price'       => ['sometimes', 'numeric', 'gte:0'],
            'category_id' => ['sometimes', 'nullable', 'exists:categories,id'],
        ]);

        $product->update($data);

        // Xóa cache cũ vì dữ liệu đã thay đổi
        Cache::forget('products');

        // Trả về sản phẩm đã cập nhật cùng với category
        return response()->json($product->load('category'), 200);
    }

    /**
     * Xóa một sản phẩm.
     * DELETE /api/products/{product}
     */
    public function destroy(Product $product)
    {
        $product->delete();

        // Xóa cache cũ vì dữ liệu đã thay đổi
        Cache::forget('products');

        return response()->json(null, 204);
    }
}
