<?php

namespace App\Http\Controllers\Invoice\Selected;

use App\Filters\Core\User\UserFilter;
use App\Filters\Invoice\Common\NameFilter;
use App\Filters\Invoice\Product\ProductFilter;
use App\Http\Controllers\Controller;
use App\Http\Resources\Invoice\CustomerPaymentMethodCollection;
use App\Models\Invoice\Country\Country;
use App\Models\Invoice\Note\Note;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Models\Invoice\Product\Product;
use App\Models\Invoice\Supplier\Supplier;
use App\Models\Invoice\Recurring\RecurringType;
use App\Models\Invoice\Tax\Tax;
use App\Models\User;
use App\Repositories\Core\StatusRepository;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;

class SelectedController extends Controller
{
    public function country(): \Illuminate\Database\Eloquent\Collection|\Illuminate\Http\JsonResponse|array
    {
        if ($response = check_permission(['create_customers', 'update_customers', 'manage_global_access'])) {
            return $response;
        }

        return Country::query()->get();
    }

    public function customer()
    {
        if ($response = check_permission([
            'create_estimates',
            'update_estimates',
            'create_invoices',
            'update_invoices',
            'manage_global_access'])) {
            return $response;
        }

        return User::query()
            ->filter(new UserFilter())
            ->select('id', 'first_name', 'last_name')
            ->withWhereHas('roles', fn($query) => $query->where('alias', 'customer'))
            ->paginate(request('per_page', 10));
    }

    public function product()
    {
        if ($response = check_permission([
            'create_estimates',
            'update_estimates',
            'create_invoices',
            'update_invoices',
            'manage_global_access'])) {
            return $response;
        }

        return Product::query()
            ->filter(new ProductFilter())
            ->select('id', 'name', 'price')
            ->orderByDesc('id')
            ->paginate(request('per_page', 10));
    }

    public function status()
    {
        return resolve(StatusRepository::class)->statuses(request()->get('type'));
    }

    public function tax()
    {
        if ($response = check_permission([
            'create_estimates',
            'update_estimates',
            'create_invoices',
            'update_invoices',
            'manage_global_access'])) {
            return $response;
        }

        return Tax::query()
            ->select('id', 'name', 'rate')
            ->get();
    }

    public function recurringType(): \Illuminate\Database\Eloquent\Collection|\Illuminate\Http\JsonResponse|array
    {
        if ($response = check_permission(['create_invoices', 'update_invoices', 'manage_global_access'])) {
            return $response;
        }

        return RecurringType::query()->select('id', 'name')->get();
    }

    public function paymentMethod()
    {
        if ($response = check_permission(['due_payment_invoice', 'manage_global_access'])) {
            return $response;
        }

        return PaymentMethod::query()
            ->filter(new NameFilter())
            ->when(auth()->user()->can('manage_global_access'), fn($query) => $query->whereNotIn('type', ['paypal', 'stripe']))
            ->get();
    }



    public function suppliers(): \Illuminate\Database\Eloquent\Collection|\Illuminate\Http\JsonResponse
    {
        if ($response = check_permission(['create_expenses', 'update_expenses', 'manage_global_access'])) {
            return $response;
        }

        return Supplier::query()->select('id', 'name')->orderBy('name')->get();
    }

    public function customerPaymentMethod(): \Illuminate\Http\JsonResponse|\Illuminate\Http\Resources\Json\AnonymousResourceCollection
    {
        if ($response = check_permission(['customer_due_invoice_payment'])) {
            return $response;
        }

        $paymentMethods = PaymentMethod::query()
            ->with('settings')
            ->whereIn('type', ['paypal', 'stripe', 'razorpay'])
            ->select(['id', 'name', 'type'])
            ->get();

        return CustomerPaymentMethodCollection::collection($paymentMethods);
    }

    public function allPaymentMethod(): LengthAwarePaginator
    {
        return PaymentMethod::query()
            ->filter(new NameFilter())
            ->paginate(request('per_page', 10));
    }

    public function note(): LengthAwarePaginator|\Illuminate\Http\JsonResponse
    {
        if ($response = check_permission(['create_invoices',
            'update_invoices',
            'create_estimates',
            'update_estimates',
            'manage_global_access'])) {
            return $response;
        }

        return Note::query()
            ->where('type', request('type', 'invoice'))
            ->paginate(request('per_page', 10));
    }
}
