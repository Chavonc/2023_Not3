<?php

namespace app\controllers;

use Yii;
use yii\console\Controller;
use Ratchet\Server\IoServer;
use Ratchet\Http\HttpServer;
use Ratchet\WebSocket\WsServer;
use app\websocket\WebSocketHandler;

class WebSocketController extends Controller
{
    public function actionStartWebSocketServer()
    {
        // 配置 WebSocket 处理程序类
        $handler = new WebSocketHandler(); // YourWebSocketHandler 是您编写的处理程序类

        // 创建 WebSocket 服务器
        $server = IoServer::factory(
            new HttpServer(
                new WsServer($handler)
            ),
            8080 // 监听的端口
        );

        // 启动 WebSocket 服务器
        $server->run();
    }
}
