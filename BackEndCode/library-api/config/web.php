<?php

$params = require __DIR__ . '/params.php';
$db = require __DIR__ . '/db.php';

$config = [
    'id' => 'basic',
    'basePath' => dirname(__DIR__),
    'bootstrap' => ['log'],
    'aliases' => [
        '@bower' => '@vendor/bower-asset',
        '@npm'   => '@vendor/npm-asset',
    ],
    'components' => [
        'request' => [
            // !!! insert a secret key in the following (if it is empty) - this is required by cookie validation
            'cookieValidationKey' => '614Yu-oYJJ4otRNGJgCXhp3XltQxeHnt',
            'parsers' => [
                'application/json' => 'yii\web\JsonParser',
            ]
        ],
        // 自定義返回數據的數據模板
        // 'response' => [
        //     'class' => 'yii\web\Response',
        //     'on beforeSend' => function ($event) {
        //         $response = $event->sender;
        //         $data = $response->data;
        //         if ($data !== null) {
        //             $response->data = [
        //                 'code' => isset($data['code']) ? $data['code'] : 200,
        //                 'message' => isset($data['message']) ? $data['message'] : null,
        //                 'data' => isset($data['data']) ? $data['data'] : $data
        //             ];
        //         }
        //     }
        // ],
        'cache' => [
            'class' => 'yii\caching\FileCache',
        ],
        'user' => [
            //'identityClass' => 'app\models\User',//////////////////////////////////////////////////////////
            'identityClass' => 'app\models\AccessToken',
            'enableAutoLogin' => true,
            'enableSession'=> false,
            'loginUrl' => null,
        ],
        'errorHandler' => [
            'errorAction' => 'site/error',
        ],
        'mailer' => [
            'class' => \yii\symfonymailer\Mailer::class,
            'viewPath' => '@app/mail',
            // send all mails to a file by default.
            'useFileTransport' => true,
        ],
        'log' => [
            'traceLevel' => YII_DEBUG ? 3 : 0,
            'targets' => [
                [
                    'class' => 'yii\log\FileTarget',
                    'levels' => ['error', 'warning'],
                ],
            ],
        ],
        'db' => $db,
        
        'urlManager' => [
            'enablePrettyUrl' => true,
            'enableStrictParsing' => true,
            'showScriptName' => false,
            'rules' => [
                // 'GET loans' => 'loan/index',
                // 'POST loans' => 'loan/borrow',
                // gardener
                [
                    'class' => 'yii\rest\UrlRule', 
                    'controller' => 'gardener',
                    'extraPatterns'=>[
                        //'GET $id'=>'$id',
                        'POST login' => 'login',
                        'POST signup-test' => 'signup-test',
                        'POST qqq' => 'qqq',
                        'POST logout' => 'logout',
                        'POST edit' => 'edit',
                        'POST info' => 'info',
                        'POST search' => 'search',
                        'POST edit-avatar' => 'edit-avatar',
                        'POST info' => 'info', 
                        'POST show-info' => 'show-info',
                        'POST show-info-avatar' => 'show-info-avatar',
                        'POST get-other-avatar' => 'get-other-avatar',
                    ],
                ],
                // gardenerofleaf
                [
                    'class' => 'yii\rest\UrlRule', 
                    'controller' => 'gardenerofleaf',
                    'extraPatterns'=>[
                        'POST get-all-gardener' => 'find-all-gardener-of-leaf',
                        'POST add-gardener' => 'add-gardener',
                        'POST delete-gardener' => 'delete-gardener',
                        'POST add-ppt-file' => 'add-ppt-file',
                        'POST add-ppt-data' => 'add-ppt-data',
                        'POST update-ppt' => 'update-ppt'
                    ],
                ],
                // leaf
                [
                    'class' => 'yii\rest\UrlRule', 
                    'controller' => 'leaf',
                    'extraPatterns'=>[
                        'POST save-vedio' => 'save-vedio',
                        'POST create-normal-leaf' => 'create-normal-leaf',
                        'POST create-white-leaf' => 'create-white-leaf',
                        'POST add-gardener' => 'add-gardener',
                        'POST report' => 'report',
                        'POST add-my-favorite' => 'add-my-favorite',
                        'POST add-my-hate' => 'add-my-hate',
                        'POST show-my-favorite' => 'show-my-favorite',
                        'POST show-my-hate' => 'show-my-hate',
                        'POST save-record' => 'save-record',
                        'POST show-gardener-leaf-file' => 'show-gardener-leaf-file',
                        'POST disable-room' => 'disable-room',
                        'POST catch-link' => 'catch-link'
                    ],
                ],
                // fastboard沒用了
                // [
                //     'class' => 'yii\rest\UrlRule', 
                //     'controller' => 'fastboard',
                //     'extraPatterns'=>[
                //         'POST create-room' => 'create-room',
                //     ],
                // ],
                // access-token
                [
                    'class' => 'yii\rest\UrlRule', 
                    'controller' => 'access-token',
                    'extraPatterns'=>[
                        'GET $id'=>'$id',
                        'GET signup-test' => 'signup-test',
                        'GET qqq' => 'qqq',
                    ],
                ],
                // article
                [
                    'class' => 'yii\rest\UrlRule',
                    'controller' => 'article',
                    'extraPatterns'=>[
                    ],
                ],
                // chat
                [
                    'class' => 'yii\rest\UrlRule',
                    'controller' => 'chat',
                    'extraPatterns' => [
                        'POST send-message' => 'send-message',
                        'POST record' => 'record',
                    ],
                ],
                // plant
                [
                    'class' => 'yii\rest\UrlRule',
                    'controller' => 'plant',
                    'extraPatterns' => [
                        'POST create-plant' => 'create-plant',
                        'POST show-all-plants' => 'show-all-plants',
                        'POST show-file' => 'show-file',
                        'POST show-fruit-info' => 'show-fruit-info',
                        'POST show-plant-picture' => 'show-plant-picture',
                        'POST harvest-fruit' => 'harvest-fruit',
                        'POST show-riv' => 'show-riv',
                    ],
                ],
            ],
        ]
    ],
    'params' => $params,
];

if (YII_ENV_DEV) {
    // configuration adjustments for 'dev' environment
    $config['bootstrap'][] = 'debug';
    $config['modules']['debug'] = [
        'class' => 'yii\debug\Module',
        // uncomment the following to add your IP if you are not connecting from localhost.
        //'allowedIPs' => ['127.0.0.1', '::1'],
    ];

    $config['bootstrap'][] = 'gii';
    $config['modules']['gii'] = [
        'class' => 'yii\gii\Module',
        // uncomment the following to add your IP if you are not connecting from localhost.
        //'allowedIPs' => ['127.0.0.1', '::1'],
    ];
}

return $config;