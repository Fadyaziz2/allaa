<?php

namespace Database\Seeders\Core\Notification;

use App\Models\Core\Notification\NotificationTemplate;
use App\Models\Core\Notification\NotificationType;
use Database\Seeders\Core\Traits\DisableForeignKeys;
use Illuminate\Database\Seeder;

class NotificationTemplateSeeder extends Seeder
{
    use DisableForeignKeys;

    public function run(): void
    {
        $this->disableForeignKeys();
        NotificationTemplate::query()->truncate();

        $templates = [
            [
                'subject' => 'Password reset link provided by {app_name}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hi {receiver_name}</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">
You are receiving this email because we received a password reset request for your account.<br>Here is your {otp_number}</p><p style="width:70%;margin:0 auto;text-align:center;color:#718096;font-size:16px;padding:35px;background:var(--card-color)"><a href="{button_url}" style="width:70%;margin:0 auto;background:#00aaf0;padding:10px 15px;width:140px;margin:0 auto;border-radius:24px;color:#fff;text-decoration:none;">Reset password</a></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">If you do not request a password reset, no further action in required</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('reset_password'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => 'User invitation from {app_name}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hi {receiver_name}</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">You\'ve been invited to {app_name} portal. To finish setting up your account, simply click the below button.</p><p style="width:70%;margin:0 auto;text-align:center;color:#718096;font-size:16px;padding:35px;background:var(--card-color)"><a href="{button_url}" style="width:70%;margin:0 auto;background:#00aaf0;padding:10px 15px;width:140px;margin:0 auto;border-radius:24px;color:#fff;text-decoration:none;">Accept Invitation</a></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Thanks & Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('user_invitation'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => 'A new user has joined {app_name}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hi {receiver_name}</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">We are delighted to inform you that your invitation to join {company_name}  has been accepted by {name}.</p><p style="width:70%;margin:0 auto;text-align:center;color:#718096;font-size:16px;padding:35px;background:var(--card-color)"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Thank you for being with us.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('user_joined'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => null,
                'default_content' => 'A new user has joined {app_name}',
                'custom_content' => null,
                'type' => 'database',
                'notification_type_id' => $this->notificationType('user_joined'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => 'Invitation for {app_name}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hi {receiver_name}</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Welcome to {app_name}! We\'re excited to have you on board and want you to ensure that your account is secure.<br><br><b>Email:</b> {email}<br><b>Password:</b> {password}<br><br>To set up your password and complete your account settings please click on the below link</p><p style="width:70%;margin:0 auto;text-align:center;color:#718096;font-size:16px;padding:35px;background:var(--card-color)"><a href="{button_url}" style="width:70%;margin:0 auto;background:#00aaf0;padding:10px 15px;width:140px;margin:0 auto;border-radius:24px;color:#fff;text-decoration:none;">Go to your account</a></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">We look forward to providing you with a secure and seamless experience.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('customer_credential'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => 'Invoice {invoice_number} for due {due_date}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hello {receiver_name},</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hope this email finds you well.<br><br>Attached to this email, you will find the invoice for the services/produtcs provided to you. Please review the details carefully, and if you have any questions or concerns regarding the invoice, do not hesitate to contact us. <br><br>Thank you for your business. We look forward to serving you again in the future.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('invoice_sending_attachment'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => 'Payment received',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hello {receiver_name},</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">We are excited to inform you that a payment has been received from your client. This payment has been successfully processed and credited to your account. Please see attached invoice <b>{invoice_number}.</b></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">To review the payment and access a detailed record of all your transactions, you can log in to your account.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('payment_received'),
                'created_at' => now(),
                'updated_at' => now()
            ],
            [
                'subject' => 'Quotation from {app_name}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hello {receiver_name},</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Thank you for providing us the opportunity to do business with you. Please see attached quotation <b>{quotation_number}</b>. We look forward to doing business together.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Feel free to contact us, if you have any questions.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('quotation_sending_attachment'),
                'created_at' => now(),
                'updated_at' => now()
            ],

            [
                'subject' => 'Invoice {invoice_number} for due {due_date}',
                'default_content' => '<p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)"><img width="auto" height="50px" src="{app_logo}"></p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Hello,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Please see attached invoice: <b>{invoice_number}</b><br><br>Feel free to contact us, if you have any questions. Thank you for being with us.</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:25px 25px 0;background:var(--card-color)">Regards,</p><p style="width:70%;margin:0 auto;color:#718096;font-size:16px;padding:0 25px 25px;background:var(--card-color)">{app_name}</p>',
                'custom_content' => null,
                'type' => 'mail',
                'notification_type_id' => $this->notificationType('recurring_sending_attachment'),
                'created_at' => now(),
                'updated_at' => now()
            ]

        ];

        NotificationTemplate::query()->insert($templates);
    }

    public function notificationType($type)
    {
        return NotificationType::query()->where('name', $type)
            ->first()
            ->id;
    }
}
