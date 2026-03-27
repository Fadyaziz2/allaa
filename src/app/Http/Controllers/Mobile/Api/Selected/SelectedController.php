<?php

namespace App\Http\Controllers\Mobile\Api\Selected;

use App\Filters\Core\User\UserFilter;
use App\Filters\Invoice\Common\NameFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Invoice\CustomerPaymentMethodCollection;
use App\Http\Resources\Mobile\Category\CategoryResourceCollection;
use App\Http\Resources\Mobile\Customer\CustomerResourceCollection;
use App\Http\Resources\Mobile\Note\NoteResourceCollection;
use App\Http\Resources\Mobile\PaymentMethod\CustomerPaymentMethodResource;
use App\Http\Resources\Mobile\PaymentMethod\PaymentMethodShowResource;
use App\Http\Resources\Mobile\Selected\CustomerNameResourceCollection;
use App\Http\Resources\Mobile\Selected\NameResourceCollection;
use App\Http\Resources\Mobile\Selected\SelectedProductResourceCollection;
use App\Http\Resources\Mobile\Tax\TaxResourceCollection;
use App\Http\Resources\Mobile\Unit\UnitResourceCollection;
use App\Models\Core\Role\Role;
use App\Models\Invoice\Category\Category;
use App\Models\Invoice\Note\Note;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Tax\Tax;
use App\Models\Invoice\Unit\Unit;
use App\Models\User;

class SelectedController extends Controller
{
    public function categories(): \Illuminate\Http\JsonResponse
    {
        $categories = Category::query()
            ->filter(new NameFilter())
            ->where('type', request('type', 'category'))
            ->select('id', 'name')
            ->orderByDesc('id')
            ->latest()
            ->get();

        return success_response('Data fetched successfully', $categories);
    }

    public function units()
    {
        $units = Unit::query()
            ->filter(new NameFilter())
            ->select('id', 'name')
            ->orderByDesc('id')
            ->get();

        return success_response('Data fetched successfully', $units);
    }

    public function noteTypes(): \Illuminate\Http\JsonResponse
    {
        $types = [
            [
                'id' => 'invoice',
                'name' => 'Invoice'
            ],
            [
                'id' => 'estimate',
                'name' => 'Quotation'
            ]
        ];

        return success_response('Data fetched successfully', $types);
    }

    public function paymentMethods(): \Illuminate\Http\JsonResponse
    {
        $methods = [
            [
                'id' => 'others',
                'name' => 'Others'
            ],
            [
                'id' => 'paypal',
                'name' => 'Paypal'
            ],
            [
                'id' => 'stripe',
                'name' => 'Stripe'
            ],
            [
                'id' => 'sslcommerz',
                'name' => 'Sslcommerz'
            ],
            [
                'id' => 'razorpay',
                'name' => 'Razorpay'
            ],
        ];

        return success_response('Data fetched successfully', $methods);
    }

    public function customers(): \Illuminate\Http\JsonResponse
    {
        $customers = User::query()
            ->filter(new UserFilter())
            ->select('id', 'first_name', 'last_name')
            ->whereHas('role', fn($q) => $q->where('alias', 'customer'))
            ->orderByDesc('id')
            ->get();
//            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new CustomerNameResourceCollection($customers));
    }

    public function products(): \Illuminate\Http\JsonResponse
    {
        $products = Product::query()
            ->filter(new NameFilter())
            ->select('id', 'name', 'price')
            ->orderByDesc('id')
            ->get();
//            ->paginate(request('per_page', 10));

        return success_response('Data fetched successfully', new SelectedProductResourceCollection($products));
    }

    public function taxes()
    {
        $taxes = Tax::query()
            ->filter(new NameFilter())
            ->select('id', 'name', 'rate')
            ->orderByDesc('id')
            ->get();

        return success_response('Data fetched successfully', $taxes);
    }

    public function notes()
    {
        $notes = Note::query()
            ->filter(new NameFilter())
            ->orderByDesc('id')
            ->get();

        return success_response('Data fetched successfully', $notes);
    }

    public function discountTypes(): \Illuminate\Http\JsonResponse
    {
        return success_response('Data fetched successfully', [
            [
                'id' => 'fixed',
                'name' => 'Fixed'
            ],
            [
                'id' => 'percentage',
                'name' => 'Percentage'
            ]
        ]);
    }

    public function paymentMethodList(): \Illuminate\Http\JsonResponse
    {
        $methods = PaymentMethod::query()
            ->select('id', 'name')
            ->orderByDesc('id')
            ->get();
        return success_response('Data fetched successfully', $methods);
    }

    public function customerPaymentMethod()
    {
        $paymentMethods = PaymentMethod::query()
            ->with('settings')
            ->whereIn('type', ['paypal', 'stripe', 'razorpay','sslcommerz'])
            ->select(['id', 'name', 'type'])
            ->get();

        return success_response('Data fetched successfully', CustomerPaymentMethodResource::collection($paymentMethods));
    }

    public function roles()
    {
        $roles = Role::query()
            ->orderByDesc('id')
            ->select('id','name','is_admin','is_default')
            ->get();

        return success_response('Data fetched successfully', $roles);
    }

}
