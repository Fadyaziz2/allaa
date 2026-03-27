<?php

namespace Database\Factories\Invoice\Providers;

use Faker\Provider\Base;

class ProductProvider extends Base
{
    protected static array $productNames = [
        '4K Ultra HD Smart TV', 'Bluetooth Noise Cancelling Headphones', 'Wireless Gaming Mouse',
        'Portable Bluetooth Speaker', 'Smart WiFi LED Light Bulb', 'Ergonomic Office Chair',
        'Stainless Steel Water Bottle', 'Wireless Earbuds', 'Smart Home Security Camera',
        'Electric Kettle', 'Digital Air Fryer', 'Smart Fitness Watch', 'Cordless Vacuum Cleaner',
        'Home Theater Projector', 'USB-C Hub Adapter', 'Portable Power Bank', 'Noise Cancelling Sleep Mask',
        'Instant Digital Camera', 'Automatic Pet Feeder', 'Smart WiFi Thermostat', 'Electric Pressure Cooker',
        'Portable Camping Stove', 'Electric Toothbrush', 'Smart Body Scale', 'Adjustable Laptop Stand',
        'Robot Mop and Vacuum Cleaner', 'LED Desk Lamp with USB Charging Port', 'Noise Cancelling Bluetooth Headphones',
        'Smart WiFi Garage Door Opener', 'Stainless Steel Travel Mug', 'Electric Wine Opener', 'Digital Food Scale',
        'Portable Mini Fridge', 'Smart Doorbell Camera', 'Cordless Handheld Vacuum', 'Electric Standing Desk',
        'Smart Alarm Clock', 'Wireless Charging Pad', 'Rechargeable Hand Warmer', 'Portable Solar Charger',
        'Electric Heated Blanket', 'Smart Lock', 'Ultrasonic Essential Oil Diffuser', 'Foldable Bluetooth Keyboard',
        'LED Light Therapy Lamp', 'Digital Meat Thermometer', 'Smart Plant Sensor', 'Wireless Charging Mouse Pad',
        'Electric Air Purifier', 'Smart WiFi Light Switch'
    ];

    public function productName()
    {
        return static::unique()->randomElement(static::$productNames);
    }
}
