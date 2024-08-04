<?php

namespace app\models;

use Yii;
use yii\base\Model;

/**
 * LoginForm is the model behind the login form.
 *
 * @property-read Gardener|null $gardener
 * @property-read AccessToken|null $accessToken
 *
 */
class LoginForm extends Model
{
    // public $username; //原本的

    public $account;
    public $password;
    public $password_hash; //0315
    public $id;
    public $rememberMe = true;

    private $_gardener = false;
    private $_accessToken = false;

    /**
     * @return array the validation rules.
     */
    public function rules()
    {
        return [
            // account and password are both required
            [['account', 'password'], 'required'], //new add
            // rememberMe must be a boolean value
            ['rememberMe', 'boolean'],
            // password is validated by validatePassword()
            ['password', 'validatePassword'],
        ];
    }

    /**
     * Validates the password.
     * This method serves as the inline validation for password.
     *
     * @param string $attribute the attribute currently being validated
     * @param array $params the additional name-value pairs given in the rule
     */
    public function validatePassword($attribute, $params)
    {
        if (!$this->hasErrors()) {
            $gardener = $this->getGardener();
            $accessToken = $this->getAccessToken();

            if (!$gardener || !$gardener->validatePassword($this->password, $params)) { // 0315
                $this->addError($attribute, 'Incorrect account or password.');
            }
        }
    }

    /**
     * Logs in a user using the provided username and password.
     * @return bool whether the user is logged in successfully
     */

    /**
     * Finds user by [[username]]
     *
     * @return Gardener|null
     */

    //login要做cookie、已登入別再登入防呆、要帳號密碼缺一不可防呆
    public function login()
    {
        $account = $this->account; //有成功抓到帳號
        $password = $this->password;

        // return $this->gardener ? $this->gardener->getId($account,$password) : null;
        // return 'true';

        //住回來
        // return $this->validate(); //打 demo 會是true 、 打 B0929036 會是 false

        (int)$id = (int)($this->gardener->findByAccount($account))->gardener_id; //37，搜尋不到就會空
        $status = $this->gardener->findByAccount($account)->gardener_status;
        // return $status;

        //帳號存在且離線
        if ($id != NULL && $status == "離線") {
            $this->password_hash = $this->gardener->findByAccount($account)->password_hash;
            $titles = Yii::$app->db->createCommand("SELECT * FROM access_token WHERE gardener_id = '$id'")
                ->queryOne();
            if ($titles == NULL) { //判斷是否已經有此筆資料，沒有的話才新增
                $this->accessToken->gardener_id = $id;
                $this->accessToken->save(); //無論如何先新增一筆accessToken資料，待存放資料也好
            }
            if ($this->validate()) {
                $this->id = $this->gardener->findByAccount($account);
                // return $this->id;//$this->id是整筆資料

                $access_token = $this->accessToken->generateAccessToken($this->id);
                $ip = $this->gardener->getUserIP($this->id);
                Yii::$app->security->validatePassword($password, $this->password_hash);
                $isUpdated = Yii::$app->db->createCommand("UPDATE gardener SET gardener_status = '在線' WHERE account = '$this->account'")->execute();
                if ($isUpdated) {
                    return [
                        'access_token' => $access_token, //會回傳token
                        'ip_address' => $ip,
                        'password hash' => $this->password_hash,
                    ];
                } else {
                    return [
                        'error_message' => "修改失敗，資料庫沒修改"
                    ];
                }
                // return $this->gardener ? $this->gardener->getId($account,$password) : null;
                // $this->gardener->save(); //會insert一整筆資料
            }
            //帳號正確，但密碼不正確
            else {
                return [
                    'error_message' => "Password error",
                ];
            }
        }
        //帳號存在，在線
        else if ($id != NULL && $status == "在線") {
            $this->password_hash = $this->gardener->findByAccount($account)->password_hash;
            $titles = Yii::$app->db->createCommand("SELECT * FROM access_token WHERE gardener_id = '$id'")->queryOne();

            $this->accessToken->gardener_id = $id;

            if ($this->validate()) {
                $this->id = $this->gardener->findByAccount($account);
                // return $this->id; // $this->id是整筆資料

                $ip = $this->gardener->getUserIP($this->id);
                Yii::$app->security->validatePassword($password, $this->password_hash);
                if ($access_token = $this->accessToken->generateAccessToken($this->id)) {
                    return [
                        'access_token' => $access_token,
                        'ip_address' => $ip,
                        'password hash' => $this->password_hash,
                    ];
                } else {
                    return [
                        'error_message' => "修改失敗，資料庫沒修改"
                    ];
                }
            }
            //帳號正確，但密碼不正確
            else {
                return [
                    'error_message' => "Password error",
                ];
            }
            // return [
            //     'error_message' => "Already logged in, do not log in again",
            // ];
        }
        //帳號不存在
        else {
            return [
                'error_message' => "Account error",
            ];
        }
    }

    public function getGardener()
    {
        if ($this->_gardener === false) {
            $this->_gardener = Gardener::findByAccount($this->account); //是finByAccount的問題
        }
        return $this->_gardener;
    }

    public function getAccessToken() //新家的
    {
        if ($this->_accessToken === false) {
            $this->_accessToken = AccessToken::findIdentity($this->id); //用id在accessToken資料表找id的對應資料
        }
        return $this->_accessToken;
    }
}
