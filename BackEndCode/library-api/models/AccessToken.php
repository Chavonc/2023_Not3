<?php

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
class AccessToken extends \yii\db\ActiveRecord implements \yii\web\IdentityInterface
{

    private static $access_tokens = [];

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'access_token';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['gardener_id'], 'required'],
        ];
    }

    /**
     * {@inheritdoc}
     */
    // public function attributeLabels()
    // {
    //     return [
    //         'gardener_id' => 'ID',
    //         'last_name' => 'Last Name',
    //         'first_name' => 'First Name',
    //         'account' => 'Account',
    //         'password' => 'Password',
    //     ];
    // }

    public static function findIdentity($id) //使用指定的用户 ID 查找身份类的实例
    {
        // return isset(self::$gardeners[$id]) ? new static(self::$gardeners[$id]) : null; //存在就會返回其ID用戶資料，不存在返回Null
        $result = Yii::$app->db->createCommand("SELECT * FROM access_token WHERE gardener_id = '$id'")
            ->queryOne();
        return new static($result);
        // return static::findOne($id); //原本的
    }

    /**
     * {@inheritdoc}
     */
    // public static function findIdentityByAccessToken($token, $type = null) //使用指定的访问令牌查找身份类的实例
    // {
    //     foreach (self::$access_tokens as $access_token) {
    //         if ($access_token['access_token'] === $token) {
    //             return new static($access_token); //如果access_token符合，回傳[]
    //         }
    //     }

    //     return null;
    // }
    public static function findIdentityByAccessToken($token, $type = null)
    {
        return static::findOne(['access_token' => $token]);
    }

    // /**
    //  * Finds user by account
    //  *
    //  * @param string $account
    //  * @return static|null
    //  */

    //findByUsername():在LoginForm的代码中，引用了这个方法，目的是根据用户提交的username返回一个在数据表与username相同的数据项，即ActiveRecord实例

    // /**
    //  * {@inheritdoc}
    //  */
    public function getId()
    {
        // return '999';
        //回
        // $id = 0;
        // $id = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$account'")
        //     ->queryOne();
        // return null;
        //回
        return 'aaa';
        // return isset($id) ? new static($id) : null;

        // return $this->id; // 原來的
    }

    public function getAuthkey()
    {
        return $this->auth_key;
    }

    public function validateAuthKey($authKey)
    {
        return $this->auth_key === $authKey;
    }

    // /**
    //  * Validates password
    //  *
    //  * @param string $password password to validate
    //  * @return bool if password provided is valid for current user
    //  */
    public function validatePassword($password) //对用户提交的密码以及当前ActiveRecord的密码进行比较
    {
        return $this->password === $password;
    }
    // public function validatePassword($password){
    //  return $this->password === md5($password);
    // }

    public function generateAccessToken($id) //new add，每次產生accessToken的時候，同時新增created_time、expired_time
    {
        // return $id;
        $access_token = AccessToken::findOne($id->gardener_id);
        // return $access_token;
        $access_token->access_token = \Yii::$app->security->generateRandomString();
        $initial_time = date('Y/m/d H:i:s');
        $access_token->created_at = date('Y/m/d H:i:s', strtotime($initial_time) + 6 * 60 * 60);
        $access_token->expired_at = date('Y/m/d H:i:s', strtotime($access_token->created_at) + 60 * 60); //60*60要改成多久再說
        $access_token->save();
        return $access_token->access_token;
    }
}
