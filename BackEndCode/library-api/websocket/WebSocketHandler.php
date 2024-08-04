<?php

namespace app\WebSocket;

use Ratchet\MessageComponentInterface;
use Ratchet\ConnectionInterface;
use app\models\Chatdata; // 引入 Chatdata 模型

class WebSocketHandler implements MessageComponentInterface
{
    public $modelClass = 'app\models\Chatdata';
    protected $clients;

    public function __construct()
    {
        $this->clients = new \SplObjectStorage;

        // 记录 WebSocket 服务器启动信息到日志，包括当前时间戳
        error_log('WebSocket server started at ' . date('Y-m-d H:i:s') . PHP_EOL, 3, '/Users/Minna/library-api/library-api/library-api/websocket.log');
    }

    public function onOpen(ConnectionInterface $conn)
    {
        $this->clients->attach($conn);
        echo "New connection! ({$conn->resourceId})\n";
        // 记录 WebSocket 服务器启动信息到日志
        error_log('WebSocket server opened at ' . date('Y-m-d H:i:s') . PHP_EOL, 3, '/Users/Minna/library-api/library-api/library-api/websocket.log');
        // 向客户端发送欢迎消息
        $conn->send('Welcome to the WebSocket server!');
    }

    public function onMessage(ConnectionInterface $from, $msg)
    {
        // // 处理从客户端接收到的消息
        // $chatDataModel = new Chatdata();
        // $chatDataModel->message = $msg;

        // // 执行数据库操作
        // if ($chatDataModel->save()) {
        //     echo "Message saved to the database.\n";
        // } else {
        //     echo "Failed to save message to the database.\n";
        // }

        // 广播消息给所有连接的客户端
        foreach ($this->clients as $client) {
            $client->send($msg);
        }
    }

    public function onClose(ConnectionInterface $conn) {
        // 将关闭连接的客户端从$clients中删除
        $this->clients->detach($conn);
        echo "Connection {$conn->resourceId} has disconnected\n";

        // 将日志信息写入文件
        error_log('Connection '. $conn->resourceId. ' has disconnected at ' . date('Y-m-d H:i:s')  . PHP_EOL, 3, '/Users/Minna/library-api/library-api/library-api/websocket.log');
    }

    public function onError(ConnectionInterface $conn, \Exception $e)
    {
        // 处理连接发生的错误
        echo "An error occurred on connection {$conn->resourceId}: {$e->getMessage()}\n";

        // 可以选择关闭连接，或者执行其他错误处理逻辑
        $conn->close();
    }
}
