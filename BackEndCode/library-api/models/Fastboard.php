<?php
//save_fastboardData加入

namespace app\models;

use Yii;
use yii\base\NotSupportedException; //new add
use yii\behaviors\TimestampBehavior; //new add
use yii\db\ActiveRecord; //new add
use yii\web\IdentityInterface; //new add
use yii\base\Model;

/**
 * This is the model class for table "book".
 *
 * @property int $id
 * @property string|null $name
 * @property string|null $author
 * @property int|null $release_year
 * @property int|null $is_available_for_loan
 *
 * @property Loan[] $loans
 */
class Fastboard extends \yii\db\ActiveRecord implements \yii\web\IdentityInterface
{
    
    public $uuid,$teamUUID,$appUUID,$createdAt,$roomToken,$our_limit = 0;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'fastboard_create_room';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['uuid','teamUUID','appUUID'], 'required'],
            [['num_of_people'], 'int', 'max' => 200], //我先設定一場葉子最多200人
        ];
    }

    public static function findIdentity($leaf_id) //使用指定的葉子ID 查找其對應資料
    {
        return self::findOne($leaf_id);
    }

    /**
     * {@inheritdoc}
     */
    public static function findIdentityByAccessToken($token,$type = null)
    {
        return static::findOne(['access_token' => $token]);
    }

    public static function findByAccount($account) // 用 account 找該使用者的資訊
    {
        $result = Yii::$app->db->createCommand("SELECT * FROM gardener WHERE account = '$account'")
            ->queryOne();
        return new static($result);
    }
    public static function findIdByAccount($account) // 用 account 找該使用者的 id
    {
        $Id = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$account'")
            ->queryOne();
        return $Id;
    }

    public function getId()
    {
        return 'aaa';
    }

    public function getAuthkey()
    {
        return $this->auth_key;
    }

    public function validateAuthKey($authKey)
    {
        return $this->auth_key === $authKey;
    }

    //存產生完成的fastboard資料到資料庫
    public function save_fastboardData()
    {
        // return $this->our_limit; //0
        $our_limit = $this->our_limit;
        if ($our_limit == 0) {
            $show_our_limit = "無上限";
        } else {
            $show_our_limit = "$our_limit";
        }
        Yii::$app->db->createCommand("INSERT INTO `fastboard_create_room` (`uuid`,`teamUUID`,`appUUID`,`isRecord`,`isBan`,`createdAt`,`our_limit`,`roomToken`) VALUES ('$this->uuid', '$this->teamUUID','$this->appUUID','false','false','$this->createdAt','$our_limit','$this->roomToken');")->execute();
    }

    // ban房間
    public function DisableRoom()
    {
        $uuid = $this->uuid;
        Yii::$app->db->createCommand("DELETE FROM `fastboard_create_room` WHERE uuid = '$uuid'")->execute();
    }
}