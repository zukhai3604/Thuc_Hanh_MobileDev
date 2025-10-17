<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Dưới đây là cấu hình CORS cho phép ứng dụng Flutter (chạy web,
    | emulator, hoặc điện thoại thật trong cùng mạng LAN) gọi API Laravel.
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    // Cho phép tất cả method: GET, POST, PUT, PATCH, DELETE, OPTIONS
    'allowed_methods' => ['*'],

    // Cho phép truy cập từ các địa chỉ sau:
    'allowed_origins' => [
        'http://localhost:*',           // Flutter web (localhost)
        'http://127.0.0.1:*',           // Flutter web (127.0.0.1)
        'http://10.0.2.2:*',            // Android emulator
        'http://192.168.*.*:*',         // Thiết bị thật cùng mạng LAN
    ],

    // Cho phép tất cả header (Authorization, Content-Type, Accept, v.v.)
    'allowed_headers' => ['*'],

    // Nếu Flutter có gửi cookie/token qua request, bật lên true (nếu cần Sanctum)
    'supports_credentials' => false,

    /*
    |--------------------------------------------------------------------------
    | Tùy chọn bổ sung (thường giữ mặc định)
    |--------------------------------------------------------------------------
    */
    'exposed_headers' => [],
    'max_age' => 0,
];
