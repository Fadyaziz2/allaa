<?php

namespace App\Helpers\Core\Traits;

use App\Models\Invoice\Notification\DeviceToken;
use App\Services\Core\Setting\SettingService;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Google\Client as GoogleClient;

trait FirebaseNotificationTrait
{

    public function sendFcmNotification(string $title, string $body, array $userIds, string $url = null)
    {
        try {
            // Retrieve device tokens for the given user IDs
            $deviceTokens = DeviceToken::query()->whereIn('user_id', $userIds)->pluck('token')->toArray();
            // If no device tokens are found, return an error response
            if (empty($deviceTokens)) {
                return response()->json(['message' => 'No device token found'], 400);
            }

            // Retrieve Firebase server key and notification icon
            $settings = resolve(SettingService::class)->getFormattedSettings();

            $projectId = config('services.fcm.project_id'); // Insert your project ID here

            $credentialsFilePath = resource_path('json/firebase.json');

            $client = new GoogleClient();
            $client->setAuthConfig($credentialsFilePath);
            $client->addScope('https://www.googleapis.com/auth/firebase.messaging');
            $client->refreshTokenWithAssertion();
            $token = $client->getAccessToken();

            $access_token = $token['access_token'];

            foreach ($deviceTokens as $fcmToken) {
                $headers = [
                    "Authorization: Bearer $access_token",
                    'Content-Type: application/json'
                ];

                $data = [
                    "message" => [
                        "token" => $fcmToken, // Send to one device token at a time
                        "notification" => [
                            "title" => $title,
                            "body" => $body,
                        ],
                        "data" => [
                            "url" => $url,
                        ]
                    ]
                ];

                $payload = json_encode($data);

                // Initialize curl
                $ch = curl_init();
                curl_setopt($ch, CURLOPT_URL, "https://fcm.googleapis.com/v1/projects/{$projectId}/messages:send");
                curl_setopt($ch, CURLOPT_POST, true);
                curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
                curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
                curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
                curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
                curl_setopt($ch, CURLOPT_VERBOSE, true); // Enable verbose output for debugging

                $response = curl_exec($ch);
                $err = curl_error($ch);
                curl_close($ch);

                // Decode the response to check for errors
                $responseArray = json_decode($response, true);

                if ($err) {
                    Log::error('Curl error: ' . $err);
                } elseif (isset($responseArray['error'])) {
                    // Handle specific FCM error codes
                    $errorCode = $responseArray['error']['details'][0]['errorCode'] ?? null;

                    if ($errorCode === 'INVALID_ARGUMENT') {
                        // Invalid token
                        Log::warning("Invalid FCM token: $fcmToken");
                    } elseif ($errorCode === 'UNREGISTERED') {
                        // Token is unregistered
                        Log::info("Unregistered FCM token: $fcmToken");
                        // Remove the unregistered token
                    } else {
                        Log::error('FCM error: ' . $response);
                    }
                } else {
                    Log::info("FCM notification sent successfully to token: $fcmToken");
                }
            }

            return response()->json(['message' => 'Notifications sent'], 200);

        } catch (\Exception $exception) {
            Log::error($exception->getMessage());
            return response()->json(['message' => 'Failed to send notifications'], 500);
        }
    }

}
