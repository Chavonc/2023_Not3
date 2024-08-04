<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;


class Chatpartnerlist extends \yii\db\ActiveRecord
{
    public $sender_id;
    public $receiver_id;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'chat_partner_list';
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

    public function generateChatpartnerlist()
    {
        // 傳送方
        $sender_id = $this->sender_id;
        // $sender_name = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id  = '$sender_id'")->queryOne());

        // 接收方
        $receiver_id = $this->receiver_id;
        // $receiver_name = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id  = '$receiver_id'")->queryOne());

        // 查db中是否存在
        $exist = implode(Yii::$app->db->createCommand("SELECT count(*) FROM chat_partner_list WHERE my_id = '$sender_id' AND partner_id = '$receiver_id';")->queryOne());
        if ($exist == 0) { // db中不存在
            // 寫入db
            Yii::$app->db->createCommand("INSERT INTO `chat_partner_list` (`my_id`,`partner_id`) VALUES ('$sender_id', '$receiver_id');")->execute();
        }
    }
}