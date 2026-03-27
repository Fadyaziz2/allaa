<?php

namespace App\Http\Controllers\Invoice\Invoice;

use App\Exceptions\GeneralException;
use App\Http\Controllers\Controller;
use App\Models\Core\Setting\Setting;
use App\Models\Invoice\Invoice\Invoice;
use App\Models\Invoice\PaymentMethod\PaymentMethod;
use App\Repositories\Core\SettingRepository;
use App\Services\Invoice\Invoice\InvoiceService;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Srmklive\PayPal\Services\PayPal as PayPalClient;
use Stripe\{Charge, Stripe};
use Razorpay\Api\Api;
use App\Helpers\Core\Traits\FirebaseNotificationTrait;


class InvoicePaymentController extends Controller
{

    use FirebaseNotificationTrait;


    public function __construct(InvoiceService $service)
    {
        $this->service = $service;
    }

    /**
     * @throws \Throwable
     */
    public function payment(Request $request, Invoice $invoice)
    {
        $request->validate([
            'payment_method' => ['required']
        ]);

        if ($request->payment_method === 'paypal') {
            $this->setPaypalConfig($this->paymentFormatSetting('paypal'));


            $provider = new PayPalClient;
            $provider->setApiCredentials(config('paypal'));
            $provider->getAccessToken();

            $parameter = [
                'invoice' => $invoice->id,
                'user' => auth()->id(),
            ];

            $response = $provider->createOrder([
                "intent" => "CAPTURE",
                "application_context" => [
                    "return_url" => route('paypal.payment-execute', ['query' => Crypt::encrypt($parameter)]),
                    "cancel_url" => route('paypal.payment-cancel'),
                ],
                "purchase_units" => [
                    0 => [
                        "amount" => [
                            "currency_code" => "USD",
                            "value" => $invoice->due_amount
                        ]
                    ]
                ]
            ]);

            if (isset($response['id']) && $response['id'] != null) {
                foreach ($response['links'] as $links) {
                    if ($links['rel'] == 'approve') {
                        return response()->json([
                            'url' => $links['href']
                        ]);
                    }
                }

            }

            throw new GeneralException(__('default.paypal_credential_has_been_wrong'));

        } elseif ($request->payment_method === 'stripe') {

            $stripeSetting = $this->paymentFormatSetting('stripe');

            if (!$stripeSetting) {
                throw new GeneralException(__('default.stripe_credentials_not_found'));
            }

            Stripe::setApiKey($stripeSetting['api_secret']);

            try {
                $user = auth()->user();
                $charge = Charge::create([
                    'amount' => ($invoice->due_amount * 100),
                    'currency' => 'usd',
                    'source' => $request->token,
                    'description' => 'App name' . ' ' . config()->get('app.name') . ' ' . 'User name' . ' ' . $user->full_name . ' ' . 'User email' . ' ' . $user->email,
                ]);

                if ($charge->status == 'succeeded') {
                    DB::transaction(function () use ($invoice) {
                        $request['received_on'] = date('Y-m-d');
                        $request['payment_method_id'] = PaymentMethod::query()
                            ->where('type', 'stripe')
                            ->first()->id;
                        $request['user_id'] = auth()->id();

                          // Construct the body message for the notification
                          $bodyMessage = sprintf(
                            'A payment of %s has been received for invoice %s.',
                            number_format($invoice->due_amount, 2),
                            $invoice->invoice_full_number
                        );

                        // Send firebase notification to the author
                        $this->sendFcmNotification('Stripe Payment Received', $bodyMessage, [$invoice->created_by],'payment');

                        $this->service
                            ->setModel($invoice)
                            ->transaction($request);
                    });

                    return response()->json([
                        'message' => trans('default.payment_has_been_successfully'),
                    ]);
                }
            } catch (Exception $e) {
                throw new GeneralException(__('default.payment_has_been_failed'));
            }
        } elseif ($request->payment_method === 'razorpay') {
            $paymentId = $request['razorpay_payment_id'];
            $razorpaySetting = $this->paymentFormatSetting('razorpay');
            $api = new Api($razorpaySetting['api_key'], $razorpaySetting['api_secret']);
            $payment = $api->payment->fetch($paymentId);
            if ($paymentId) {
                try {
                    $response = $api->payment->fetch($paymentId)->capture([
                        'amount' => $invoice->due_amount * 100
                    ]);

                    DB::transaction(function () use ($invoice) {
                        $request['received_on'] = date('Y-m-d');
                        $request['payment_method_id'] = PaymentMethod::query()
                            ->where('type', 'razorpay')
                            ->first()->id;
                        $request['user_id'] = auth()->id();

                         // Construct the body message for the notification
                         $bodyMessage = sprintf(
                            'A payment of %s has been received for invoice %s.',
                            number_format($invoice->due_amount, 2),
                            $invoice->invoice_full_number
                        );

                        // Send firebase notification to the author
                        $this->sendFcmNotification('Razorpay Payment Received', $bodyMessage, [$invoice->created_by],'payment');

                        $this->service
                            ->setModel($invoice)
                            ->transaction($request);
                    });

                    return response()->json([
                        'message' => trans('default.payment_has_been_successfully'),
                    ]);
                    
                } catch (Exception $e) {
                    DB::rollBack();
                    throw new GeneralException(__('default.payment_has_been_failed'));
                }
            }

        }
    }


    /**
     * @throws \Throwable
     */
    public function successTransaction(Request $request): \Illuminate\Http\RedirectResponse
    {

        $this->setPaypalConfig($this->paymentFormatSetting('paypal'));
        $provider = new PayPalClient;
        $provider->setApiCredentials(config('paypal'));
        $provider->getAccessToken();
        $response = $provider->capturePaymentOrder($request['token']);
        if (isset($response['status']) && $response['status'] == 'COMPLETED') {

            $decrypt = Crypt::decrypt(request('query'));
            $invoice = $this->service->find($decrypt['invoice']);


            DB::transaction(function () use ($decrypt, $invoice) {
                $request['received_on'] = date('Y-m-d');
                $request['payment_method_id'] = PaymentMethod::query()->where('type', 'paypal')->first()->id;
                $request['user_id'] = $decrypt['user'];

                    // Construct the body message for the notification
                    $bodyMessage = sprintf(
                        'A payment of %s has been received for invoice %s.',
                        number_format($invoice->due_amount, 2),
                        $invoice->invoice_full_number
                        );
        
                    // Send firebase notification to the author
                    $this->sendFcmNotification('Paypal Payment Received', $bodyMessage, [$invoice->created_by],'payment');

                $this->service->setModel($invoice)
                    ->transaction($request);

            });

            return redirect()->intended('invoices?payment=success');

        } else {
            return redirect()->intended('invoices?payment=error');
        }
    }

    public function paymentFormatSetting($context)
    {
        return resolve(SettingRepository::class)
            ->formatSettings(Setting::query()
                ->where('context', $context)
                ->get()
            );
    }

    /**
     * @throws GeneralException
     */
    private function setPaypalConfig($paypalSetting): void
    {
        if (!$paypalSetting) {
            throw new GeneralException(__('default.paypal_credentials_not_found'));
        }
        if ($paypalSetting['payment_mode'] === 'sandbox') {
            config()->set('paypal.mode', $paypalSetting['payment_mode']);
            config()->set('paypal.sandbox.client_id', $paypalSetting['api_key']);
            config()->set('paypal.sandbox.client_secret', $paypalSetting['api_secret']);
        }

        if ($paypalSetting['payment_mode'] === 'live') {
            config()->set('paypal.mode', $paypalSetting['payment_mode']);
            config()->set('paypal.live.client_id', $paypalSetting['api_key']);
            config()->set('paypal.live.client_secret', $paypalSetting['api_secret']);
        }
    }

}
