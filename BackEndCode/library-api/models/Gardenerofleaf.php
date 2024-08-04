<?php
namespace app\models;

use PhpParser\Node\Expr\Cast\String_;
use Yii;
use yii\base\NotSupportedException; //new add
use yii\behaviors\TimestampBehavior; //new add
use yii\db\ActiveRecord; //new add
use yii\web\IdentityInterface; //new add
use yii\base\Model;

class Gardenerofleaf extends \yii\db\ActiveRecord
{
    public $leaf_id, $gardener_account;
    public $uuid;
    public $file;
    private static $gardener_of_leafs = [];

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'gardener_of_leaf';
    }

    // /**
    //  * {@inheritdoc}
    //  */
    // public function rules()
    // {
    //     return [
    //         [['leaf_id','gardener_id','gardener_file'], 'required']
    //     ];
    // }

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

    public static function findIdentity($id) //使用指定的葉子ID 查找其對應資料(可以拿來找此場葉子的所有參與者)
    {
        return self::findOne($id);
    }
    /**
     * {@inheritdoc}
     */
    public static function findIdentityByAccessToken($token,$type = null)
    {
        return static::findOne(['access_token' => $token]);
    }
    
    public function getAllGardener() //找某場葉子的所有gardener資料
    {
        $leaf_id = $this->leaf_id;
        $check_leaf_id = Yii::$app->db->createCommand("SELECT uuid FROM `leaf` WHERE uuid = '$leaf_id';")->queryOne();

        if ($check_leaf_id == NULL) { // leaf_id不存在
            return [[
                'error_message' => "Leaf not found !"
            ]];
        }
        $result = Yii::$app->db
            ->createCommand("SELECT account, first_name FROM gardener_of_leaf JOIN gardener ON gardener_of_leaf.gardener_id = gardener.gardener_id WHERE leaf_id = '$leaf_id'")
            ->queryAll();
        // queryOne()只會找第一筆資料，即使SQL給出很多筆、queryAll()會給所有SQL出來的資料
        if ($result != NULL) {
            return $result;
        } else {
            return [[
                'error_message' => "Gardener not found !"
            ]];
        }
    }

    public function generateOneGardener() //new add
    {
        $uuid = $this->leaf_id;
        $gardener_id = $this->gardener_id;
        // check uuid是否存在
        $check_uuid = Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE uuid = '$uuid'")->queryOne();
        if ($check_uuid != NULL) {
            // 確認該user是否已在葉子中  
            $re_gardener = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener_of_leaf WHERE gardener_id = '$gardener_id' AND leaf_id = '$uuid'")->queryOne();
            if ($re_gardener == NULL) { // 該user不在葉子中
                // 原先葉子中人數
                $original_num_of_leaf = intval(implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM gardener_of_leaf WHERE leaf_id = '$uuid'")->queryOne()));
                // 寫入db
                if (Yii::$app->db->createCommand("INSERT INTO `gardener_of_leaf` (`gardener_id`,`leaf_id`) VALUES ('$gardener_id','$uuid');")->execute()) {
                    // 更改後葉子中人數
                    $new_num_of_leaf = $original_num_of_leaf + 1;
                    // 下面這個UPDATE不知道為什麼 加if判斷就無法執行
                    Yii::$app->db->createCommand("UPDATE `leaf` SET `num_of_people` = $new_num_of_leaf WHERE `uuid` = '$uuid'")->execute();
                    $attendence_of_leaf = Yii::$app->db->createCommand("SELECT num_of_people FROM leaf WHERE uuid = '$uuid'")->queryOne();
                    return [
                        "message" => "加入成功",
                        // 'uuid' => $uuid,
                        // 'gardener_id' => $gardener_id,
                        // 'original_num_of_leaf' => $original_num_of_leaf,
                        // 'attendence_of_leaf' => $attendence_of_leaf
                    ];
                } else {
                    return [
                        'error_message' => "新增至資料庫失敗!"
                    ];
                }
            } else { // 帳號已在葉子中
                return [
                    'error_message' => "帳號已存在葉子中"
                ];
            }
        } else { // uuid不存在 
            return [
                'error_message' => "Room not found !"
            ];
        }
    }

    public function deleteGardener() //刪掉某場葉子某gardener
    {
        $uuid = $this->leaf_id;
        $gardener_id = $this->gardener_id;
        // check uuid是否存在
        $check_uuid = Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE uuid = '$uuid'")->queryOne();
        if ($check_uuid != NULL) {
            // 確認該user是否已在葉子中
            $re_gardener = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener_of_leaf WHERE gardener_id = '$gardener_id' AND leaf_id = '$uuid'")->queryOne();
            if ($re_gardener != NULL) { // 該user在葉子中
                // 原先葉子中人數
                $original_num_of_leaf = intval(implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM gardener_of_leaf WHERE leaf_id = '$uuid'")->queryOne()));
                // 修改db
                if (Yii::$app->db->createCommand("DELETE FROM gardener_of_leaf WHERE leaf_id = '$uuid' AND gardener_id = '$gardener_id'")->execute()) {
                    // 更改後葉子中人數
                    $new_num_of_leaf = $original_num_of_leaf - 1;
                    // 下面這個UPDATE不知道為什麼 加if判斷就無法執行
                    Yii::$app->db->createCommand("UPDATE `leaf` SET `num_of_people` = $new_num_of_leaf WHERE `uuid` = '$uuid'")->execute();
                    $attendence_of_leaf = implode(Yii::$app->db->createCommand("SELECT num_of_people FROM leaf WHERE uuid = '$uuid'")->queryOne());
                    // 判斷是否為manager
                    $check_manager = Yii::$app->db->createCommand("SELECT manager_of_leaf_id FROM `manager_of_leaf` WHERE manager_id = '$gardener_id' AND leaf_id = '$uuid'")->queryOne();
                    if ($check_manager != NULL) { // 是manager
                        if (Yii::$app->db->createCommand("DELETE FROM manager_of_leaf WHERE leaf_id = '$uuid' AND manager_id = '$gardener_id'")->execute()) {
                        } else {
                            return [
                                'error_message' => "修改manager資料庫失敗!"
                            ];
                        }
                    }
                    // 判斷是否為founder
                    // if(){}SELECT founder_id FROM `leaf` WHERE uuid = ''
                    $check_founder = Yii::$app->db->createCommand("SELECT founder_id FROM `leaf` WHERE founder_id = '$gardener_id' AND uuid = '$uuid'")->queryOne();
                    if ($check_founder != NULL) {
                        $isFounder = "true";
                    } else {
                        $isFounder = "false";
                    }
                    // 判斷是否為最後一人
                    if ($attendence_of_leaf == 0) { // 是最後一人
                        $isLast = "true";
                    } else { // 不是最後一人
                        $isLast = "false";
                    }
                    return [
                        "message" => "成功離開",
                        "isFounder" => "$isFounder",
                        "isLast" => "$isLast"
                        // 'attendence_of_leaf' => $attendence_of_leaf
                    ];
                } else {
                    return [
                        'error_message' => "新增至資料庫失敗!"
                    ];
                }
            } else { // 該user不在葉子中
                return [
                    'error_message' => "帳號不存在葉子中"
                ];
            }
        } else { // uuid不存在
            return [
                'error_message' => "Room not found !"
            ];
        }
    }

    //找某人在某場葉子的檔案路徑和檔名
    public function findFileOfLeafInfo()
    {
        $gardener_id = $this->gardener_id;
        $leaf_id = $this->leaf_id;
        // check uuid
        $check_leaf = Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE uuid = '$leaf_id'")->queryOne(); // 確認房間是否存在
        if ($check_leaf == NULL) {
            return [
                'gardener_file_name' => false
            ];
        }
        // 正常，回傳資料
        if ($result = Yii::$app->db->createCommand("SELECT gardener_file_name,gardener_file_path FROM gardener_of_leaf WHERE gardener_id = '$gardener_id' AND leaf_id = '$leaf_id'")->queryOne()) {
            return $result;
        } else { // Gardener is not in the leaf
            return [
                'gardener_file_name' => ""
            ];
        }
    }

    public function addPpt($fileOrData)
    {
        $gardener_id = $this->gardener_id;
        $leaf_id = $this->leaf_id;
        //人不存在的話，accesstoken就會錯，不用防呆
        $check_leaf = Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE uuid = '$leaf_id'")->queryOne(); // 確認房間是否存在
        $check_gardener = Yii::$app->db->createCommand("SELECT gardener_of_leaf_id FROM gardener_of_leaf WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->queryOne(); // 確認人是否在此房間

        if ($check_leaf != NULL) {
            if ($check_gardener != NULL) {
                $account = implode(Yii::$app->db->createCommand("SELECT account FROM gardener WHERE gardener_id  = '$gardener_id'")->queryOne());

                $filePath = "/Users/Minna/library-api/library-api/library-api/empty.pptx";
                $fileContent = file_get_contents($filePath); // 取得空白ppt檔案

                $gardener_file_name = $leaf_id . "_" . $account . ".pptx"; // 生成新檔案名
                $gardener_file_path = "/Users/Minna/library-api/library-api/library-api/gardener_of_leaf_ppt/" . $gardener_file_name; // 生成新檔案路徑

                // file
                if ($fileOrData) {
                    $result = file_put_contents($gardener_file_path, $fileContent); // 放空白ppt到新資料夾(搬移)

                    if ($result) {
                        return Yii::$app->response->sendFile($gardener_file_path, $gardener_file_name);
                    } else {
                        return [
                            'error_message' => "資料夾產生空白檔案失敗"
                        ];
                    }
                }
                // data
                else {
                    $isUpdated = Yii::$app->db->createCommand("UPDATE gardener_of_leaf SET gardener_file_name = '$gardener_file_name', gardener_file_path = '$gardener_file_path' WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->execute();
                    if ($isUpdated) {
                        return [
                            'file_name' => $gardener_file_name,
                            'file_path' => $gardener_file_path
                        ];
                    } else {
                        return [
                            'error_message' => "修改失敗，資料庫沒修改",
                        ];
                    }
                }
            }
            else{
                return [
                    'error_message' => "此園丁不在房間裡"
                ];
            }
        }
        else{
            return [
                'error_message' => "此房間不存在"
            ];
        }
    }

    public function UpdatePPT()
    {
        // gardener_id
        $gardener_id = $this->gardener_id;
        // leaf_id
        $leaf_id = $this->leaf_id;

        // file
        // 檔案格式：一定要.pptx
        $file_format = $this->file->extension;
        // return $file_format;
        if ($file_format != "pptx") {
            return [
                'error_message' => "檔案格式不符!"
            ];
        }

        // 防呆
        // 確認房間是否存在
        // $check_leaf = implode(Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE uuid = '$leaf_id'")->queryOne());
        // return $check_leaf;
        // 確認人是否在此房間
        // $gardener_of_leaf_id = implode(Yii::$app->db->createCommand("SELECT gardener_of_leaf_id FROM gardener_of_leaf WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->queryOne());
        // var_dump($gardener_of_leaf_id);
        // return $gardener_of_leaf_id;
        
        if ($check_leaf = Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE uuid = '$leaf_id'")->queryOne()){
            if (Yii::$app->db->createCommand("SELECT gardener_of_leaf_id FROM gardener_of_leaf WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->queryOne()) {
                $gardener_of_leaf_id = implode(Yii::$app->db->createCommand("SELECT gardener_of_leaf_id FROM gardener_of_leaf WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->queryOne());
                $ppt_name = implode(Yii::$app->db->createCommand("SELECT gardener_file_name FROM `gardener_of_leaf` WHERE gardener_of_leaf_id = '$gardener_of_leaf_id'")->queryOne());
                $ppt_path = implode(Yii::$app->db->createCommand("SELECT gardener_file_path FROM `gardener_of_leaf` WHERE gardener_of_leaf_id = '$gardener_of_leaf_id'")->queryOne());

                if ($this->file->saveAs($ppt_path, false)) { // 放ppt到資料夾
                    return Yii::$app->response->sendFile($ppt_path, $ppt_name);
                } else {
                    return [
                        'error_message' => "存檔失敗!"
                    ];
                }
            } else {
                return [
                    'error_message' => "此園丁不在房間裡"
                ];
            }
        } else {
            return [
                'error_message' => "此房間不存在"
            ];
        }
    }
}
