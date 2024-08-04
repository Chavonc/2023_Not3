<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;
use app\models\Gardener; ////


class Chatdata extends \yii\db\ActiveRecord
{
    public $sender_id, $receiver_account; //傳送方的id、接收方的帳號
    public $chat_data;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'chat_data';
    }

    /**
     * {@inheritdoc}
     */
    // public function rules()
    // {
    //     return [
    //         [['founder_id', 'speaker_id'], 'required'],
    //         [['num_of_people'], 'int', 'max' => 200], //我先設定一場葉子最多200人
    //     ];
    // }

    public function generateChatdata()
    {
        // 傳送方
        $sender_id = $this->sender_id;
        // $sender_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$sender_acc'")->queryOne());

        // 接收方
        $receiver_acc = $this->receiver_account;
        // $receiver_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$receiver_acc'")->queryOne());

        // 防呆
        $gardener = new Gardener();
        (int)$receiver_id = (int)($gardener->findByAccount($receiver_acc))->gardener_id; //搜尋不到就會空

        // 訊息發送時間
        $initial_time = date('Y/m/d H:i:s');
        $send_time = date('Y/m/d H:i:s', strtotime($initial_time) + 6 * 60 * 60);

        

        // 訊息內容
        if ($sender_id != $receiver_id && $receiver_id != NULL) { //帳號存在
            // 傳到Chatpartnerlist
            $chatpartnerlist = new Chatpartnerlist();
            $chatpartnerlist->sender_id = $sender_id;
            $chatpartnerlist->receiver_id = $receiver_id;
            $chatpartnerlist->generateChatpartnerlist();

            $chat_data = $this->chat_data; // 訊息內容

            // 字串長度夠長 -> 可能為link； 太短 -> 一定是message
            if ($link = substr($chat_data, 26)) {
                $check_link_title = substr($chat_data, 0, 26);
                if ($check_link_title == "Someone sent you a link : ") { // 確認開頭是對的 -> link
                    $isLink = "true";
                    $real_chat_data = $link;
                } else { // 開頭是錯的 -> message
                    $isLink = "false";
                    $real_chat_data = $chat_data;
                }
            } else { // 太短 -> message
                $isLink = "false";
                $real_chat_data = $chat_data;
            }
            // 寫入db
            $isUpdated = Yii::$app->db->createCommand("INSERT INTO `chat_data` (`sender_id`,`receiver_id`,`chat_data`,`send_time`,`isLink`) VALUES ('$sender_id', '$receiver_id', '$real_chat_data','$send_time','$isLink');")->execute();
            if ($isUpdated) {
                return [
                    'chat_data' => $real_chat_data,
                    'isLink' => $isLink
                ];
            } else {
                return [
                    'error_message' => "修改失敗，資料庫沒新增"
                ];
            }
        } else if ($receiver_id == NULL) {
            return [
                'error_message' => "找不到接收方帳號"
            ];
        } else if ($sender_id == $receiver_id) {
            return [
                'error_message' => "發送方和接收方相同，不可以自己傳給自己"
            ];
        }
    }

    public function Chatrecord() // 查詢 A 和 B 的所有聊天紀錄
    {
        // B
        $b_acc = $this->receiver_account;
        // $b_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$b_acc'")->queryOne());

        // 防呆
        $gardener = new Gardener();
        (int)$a_id = (int)$this->sender_id;
        (int)$b_id = (int)($gardener->findByAccount($b_acc))->gardener_id; //搜尋不到就會空

        //b存在，且ab不是同一人
        if ($b_id != 0 && $a_id != $b_id) {
            // 共幾筆資料
            $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM chat_data WHERE ((sender_id = '$a_id' AND receiver_id = '$b_id') OR (sender_id = '$b_id' AND receiver_id = '$a_id'))")->queryOne());

            // save result 用的 array
            $result = array();

            for ($i = 0; $i < $num; $i++) {
                $one = implode(Yii::$app->db->createCommand("SELECT chat_data_id  FROM chat_data WHERE ((sender_id = '$a_id' AND receiver_id = '$b_id') OR (sender_id = '$b_id' AND receiver_id = '$a_id')) ORDER BY send_time ASC LIMIT $i,1")->queryOne());
                // 訊息內容
                $chat_data = implode(Yii::$app->db->createCommand("SELECT chat_data FROM chat_data WHERE chat_data_id = '$one'")->queryOne());
                // 訊息發送時間
                $send_time = implode(Yii::$app->db->createCommand("SELECT send_time FROM chat_data WHERE chat_data_id = '$one'")->queryOne());
                // 輸出
                $sender_name = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id = (SELECT sender_id FROM chat_data WHERE chat_data_id = '$one')")->queryOne());
                $receiver_name = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id = (SELECT receiver_id FROM chat_data WHERE chat_data_id = '$one')")->queryOne());
                $isLink = implode(Yii::$app->db->createCommand("SELECT isLink FROM chat_data WHERE chat_data_id = '$one'")->queryOne());

                $result[] = array(
                    'sender_firstname' => $sender_name,
                    'receiver_firstname' => $receiver_name,
                    'send_time' => $send_time,
                    'chat_data' => $chat_data,
                    'isLink' => $isLink
                );
            }
            if($result != null){
                return $result;
            }
            else{
                return [[
                    'error_message' => "他倆沒有聊天紀錄"
                ]];
            }
        }else if ($b_id == NULL) {
            return [[
                'error_message' => "找不到對方帳號"
            ]];
        }
        else if($a_id == $b_id){
            return [[
                'error_message' => "兩方帳號相同，不能自己跟自己聊天，所以不會有資料"
            ]];
        }
    }
}
