<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException; //new add
use yii\behaviors\TimestampBehavior; //new add
use yii\db\ActiveRecord; //new add
use yii\web\IdentityInterface; //new add
use yii\base\Model;

/**
 * This is the model class for table "Gardener".
 *
 * @property int $id
 * @property string|null $name
 * @property string|null $author
 * @property int|null $release_year
 * @property int|null $is_available_for_loan
 *
 * @property Loan[] $loans
 */
class Gardener extends \yii\db\ActiveRecord implements \yii\web\IdentityInterface
{
    //public $account, $password_hash, $first_name; //不可以打，不然會有問題
    // private static $gardeners = [];
    public $file;
    public $gardener_firstname;
    public $account1, $gardener_id1, $password1;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'gardener';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['account', 'password'], 'required'],
            [['first_name'], 'string', 'max' => 255],
            // [['file'], 'file', 'skipOnEmpty' => false, 'extensions' => 'jpg, png']
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
        //return static::findOne($id);
        return self::findOne($id);
    }

    /**
     * {@inheritdoc}
     */
    public static function findIdentityByAccessToken($token, $type = null)
    {
        // return static::findOne(['access_token' => $token]);
    }

    public static function findByAccount($account)                                                             //20220306
    {

        //return new static($this->account);
        $result = Yii::$app->db->createCommand("SELECT * FROM gardener WHERE account = '$account'")
            ->queryOne();
        // foreach ($result as $gardener) {
        // if (strcasecmp($gardener['account'], $account) === 0) {/
        // return $result; //self:: 會抓到demo demo、
        return new static($result);
        // }
        // }
        // return null;
    }

    // public static function findByAccount($account)
    // {
    //     foreach (self::$gardeners as $gardener) {
    //         if (strcasecmp($gardener['account'], $account) === 0) {
    //             return new static($gardener);
    //         }
    //     }
    //     return null;
    // }

    //findByUsername():在LoginForm的代码中，引用了这个方法，目的是根据用户提交的username返回一个在数据表与username相同的数据项，即ActiveRecord实例
    // public static function findByUsername($username){     //①
    //  return static::findOne(['username'=>$username]);
    // }

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

    //   Validates password
    public function validatePassword($password) //对用户提交的密码以及当前ActiveRecord的密码进行比较
    {
        if (Yii::$app->getSecurity()->validatePassword($password, $this->password_hash)) { //0315
            // all good, logging user in
            return true;
            // return [
            //     //$this->password === $password,
            //     // 'password' => $password,
            //     // 'password hash' => $this->password_hash
            // ];
            // echo "password ok<br>";
            // echo "password hash:" . $this->password_hash;
        } else {
            // wrong password
            return false;
            // echo "bad password";
        }
    }

    public function generateAccessToken($id) //new add                                         20230311
    {
        // return 'aaaaa';
        $gardener = Gardener::findOne($id);
        $gardener->access_token = \Yii::$app->security->generateRandomString();
        $gardener->save();
        return $gardener->access_token;
    }

    // public function generateAuthKey()//生成随机的auth_key，用于cookie登陆 //原本有
    // {
    //     $this->auth_key = \Yii::$app->security->generateRandomString();
    //     $this->save();
    // }

    public function getUserIP($id) // return ::1
    {
        $access_token = AccessToken::findOne($id);
        $IP = Yii::$app->request->userIP;
        $access_token->IP_address = $IP;
        $access_token->save();
        // if ($gardener->ip == '::1') {
        //     $gardener->ip = '123.456.789.123'; // enter your real IP address here
        // }
        return $access_token->IP_address;
    }

    public function logout()
    {
        $gardener_id = $this->gardener_id1;
        // return $gardener_id;
        $gardener_id = (int)$gardener_id;
        $isUpdated1 = Yii::$app->db->createCommand("UPDATE access_token SET access_token = null,created_at = null,expired_at = null,IP_address = null WHERE gardener_id = '$gardener_id'")->execute();
        $isUpdated2 = Yii::$app->db->createCommand("UPDATE gardener SET gardener_status = '離線' WHERE gardener_id = '$gardener_id'")->execute();
        if ($isUpdated1 and $isUpdated2) {
            return [
                'message' => "logout successful",
            ];
        } else {
            return [
                'error_message' => "修改失敗，資料庫沒修改",
            ];
        }
    }

    // 目前只可改password、first_name
    public function edit()
    {
        $gardener_id = $this->gardener_id1;
        $first_name = $this->first_name;
        $password_hash = Yii::$app->getSecurity()->generatePasswordHash($this->password1);
        $isUpdated = Yii::$app->db->createCommand("UPDATE gardener SET first_name = '$first_name',password_hash = '$password_hash' WHERE gardener_id = '$gardener_id'")->execute();
        //若執行成功
        if ($isUpdated) {
            return [
                'message' => "修改成功"
            ];
        } else {
            return [
                'error_message' => "修改失敗，資料庫沒修改"
            ];
        }
    }

    public function EditAvatar()
    {
        // file
        // 原本的名稱
        $name = $this->file->baseName;
        // 檔案格式    eg. jpg, png
        $file_format = $this->file->extension;
        // new_name : 儲存的名字
        $new_name = $name . '.' . $file_format;
        // file_path
        $file_path = '/Users/Minna/library-api/library-api/library-api/gardener頭像/' . $new_name;
        // $file_path = 'C:/Users/user/桌面/api_file_test/頭像/' . $new_name;
        // $file_path = 'C:/xampp/htdocs/library-api/library-api/avatar/' . $new_name;

        // 防呆
        //save    一定要save,才會存在路徑
        if ($this->file->saveAs($file_path, false)) {
            return [
                'message' => "頭像修改成功!"
            ];
        } else {
            return [
                'message' => "頭像修改失敗!"
            ];
        }
    }

    public function signup()
    {
        // file
        // 原本的名稱
        $name = $this->file->baseName;
        // 檔案格式    eg. jpg, png
        $file_format = $this->file->extension;
        // new_name : 儲存的名字
        $new_name = $name . '.' . $file_format;
        // file_path
        $file_path = '/Users/Minna/library-api/library-api/library-api/gardener頭像/' . $new_name;
        // $file_path = 'C:/Users/user/桌面/api_file_test/頭像/' . $new_name;
        // $file_path = 'C:\xampp\htdocs\library-api\library-api\avatar' . $new_name;

        // account
        $account = $this->account;
        $check_account = Yii::$app->db->createCommand("select account from gardener where account = '$account' LIMIT 1")->queryOne();

        // 防呆
        $first_name = $this->first_name;
        // $account = $account;
        $password = $this->password1;
        $gardener_avatar_name = $new_name;
        $gardener_avatar_path = $file_path;

        if ($first_name != null && $account != null && $password != null) {
            if ($check_account == null) {
                //寫入DB
                $password_hash = Yii::$app->getSecurity()->generatePasswordHash($password); //0315
                $isUpdated = Yii::$app->db->createCommand("INSERT INTO gardener(first_name,account,password_hash,gardener_avatar_name,gardener_avatar_path) VALUES ('$first_name','$account','$password_hash','$gardener_avatar_name','$gardener_avatar_path')")->execute();
                $gardener_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$account'")->queryOne());
                if ($isUpdated) {
                    //save    一定要save,才會存在路徑
                    $this->file->saveAs($file_path, false);
                    $plant = new PlantOfGardener();
                    $plant->gardener_id = $gardener_id;
                    $plant->plant_name = '資料夾一';
                    $plant->plant_type = '綠樹';
                    if ($plant->generatePlant()['message'] == '創建成功!') {
                        return [
                            'error_message' => "註冊成功"
                        ];
                    } else {
                        return [
                            'error_message' => "創建資料夾一失敗，先找後端到資料庫刪掉帳號",
                        ];
                    }
                } else {
                    return [
                        'error_message' => "修改失敗，資料庫沒新增",
                    ];
                }
            } else {
                return [
                    'error_message' => "帳號已存在"
                ];
            }
        } else {
            return [
                'error_message' => "資料輸入不完整"
            ];
        }
    }

    public function gardenerInfo()
    {
        // gardener_firstname
        $gardener_firstname = $this->gardener_firstname;

        // file
        // 檔案名稱
        $name = $this->file->baseName;
        // 檔案格式    eg. jpg, png
        $file_format = $this->file->extension;
        // gardener_avatar_name
        $gardener_avatar_name = $name . "." . $file_format;

        // 查db
        // 拿來判斷名字存在與否
        $if_gardener_name = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE first_name = '$gardener_firstname'")->queryOne();
        //如果名字存在
        if ($if_gardener_name != false) {
            $if_gardener_name = implode($if_gardener_name);
            // 拿來判斷檔案是否正確
            $if_file_name = implode(Yii::$app->db->createCommand("SELECT gardener_avatar_name FROM gardener WHERE gardener_id = '$if_gardener_name'")->queryOne());
            //如果檔案正確
            if ($if_file_name == $gardener_avatar_name) {
                $gardener_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE first_name = '$gardener_firstname' AND gardener_avatar_name = '$gardener_avatar_name'")->queryOne());

                $gardener_account = implode(Yii::$app->db->createCommand("SELECT account FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());
                $gardener_status = implode(Yii::$app->db->createCommand("SELECT gardener_status FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());

                return [
                    'gardener_firstname' => $gardener_firstname,
                    'gardener_account' => $gardener_account,
                    'status' => $gardener_status
                ];
            } else {
                return [
                    'error_message' => 'the avatar corresponds to the first name is wrong'
                ];
            }
        }
        //如果名字不存在
        else {
            return [
                'error_message' => 'this first name does not exist'
            ];
        }
    }

    public function ShowInfo()
    {
        $gardener_id = $this->gardener_id1;

        $gardener_account = implode(Yii::$app->db->createCommand("SELECT account FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());
        $gardener_first_name = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());
        $gardener_status = implode(Yii::$app->db->createCommand("SELECT gardener_status FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());
        $filePath = implode(Yii::$app->db->createCommand("SELECT gardener_avatar_path FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());

        if ($gardener_account and $gardener_first_name and $gardener_status) {
            return [
                'account' => $gardener_account,
                'firstname' => $gardener_first_name,
                'status' => $gardener_status,
                'file_path' => $filePath,
            ];
        } else {
            return [
                'error_message' => "資料庫資料不完整"
            ];
        }
    }

    public function ShowInfoAvatar()
    {
        $gardener_id = $this->gardener_id1;

        $fileName = implode(Yii::$app->db->createCommand("SELECT gardener_avatar_name FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());
        $filePath = implode(Yii::$app->db->createCommand("SELECT gardener_avatar_path FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());
        // Yii::$app->response->headers->set('Content-Type', 'image/jpeg');

        if ($fileName and $filePath) {
            return  Yii::$app->response->sendFile($filePath, $fileName);
        } else {
            return [
                'error_message' => "資料庫資料不完整"
            ];
        }
    }

    public function Search()
    {
        $enter_firstname = $this->gardener_firstname;

        $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM gardener WHERE first_name LIKE '%$enter_firstname%'")->queryOne());

        if ($num == 0) {
            return [[
                'error_message' => "搜尋不到資料"
            ]];
        } else {
            $result = array();

            for ($i = 0; $i < $num; $i++) {
                $one = implode(Yii::$app->db->createCommand("SELECT gardener_id  FROM gardener WHERE first_name LIKE '%$enter_firstname%' ORDER BY gardener_id ASC LIMIT $i,1")->queryOne());
                $first_names = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id = '$one'")->queryOne());
                $accounts = implode(Yii::$app->db->createCommand("SELECT account FROM gardener WHERE gardener_id = '$one'")->queryOne());

                $result[] = array(
                    'first_names' => $first_names,
                    'account' => $accounts
                );
            }
            return $result;
        }
    }

    public function GetOtherAvatar()
    {
        $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM gardener WHERE account  = '$this->account1'")->queryOne());
        if ($num != 0) {
            $fileName = implode(Yii::$app->db->createCommand("SELECT gardener_avatar_name FROM gardener WHERE account  = '$this->account1'")->queryOne());
            $filePath = implode(Yii::$app->db->createCommand("SELECT gardener_avatar_path FROM gardener WHERE account  = '$this->account1'")->queryOne());
            if ($fileName and $filePath) {
                return  Yii::$app->response->sendFile($filePath, $fileName);
            } else {
                return [
                    'error_message' => "資料庫資料不完整"
                ];
            }
        } else {
            return [
                'error_message' =>  "other的帳號不存在"
            ];
        }
    }
}
