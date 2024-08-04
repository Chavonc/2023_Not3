<?php
// save_fastboardData刪掉

namespace app\models;
use app\controllers\LeafController;
use Yii;
use yii\base\NotSupportedException; //new add
use yii\behaviors\TimestampBehavior; //new add
use yii\db\ActiveRecord; //new add
use yii\web\IdentityInterface; //new add
use yii\base\Model;
/**
 * This is the model class for table "Leaf".
 */
class Leaf extends \yii\db\ActiveRecord implements \yii\web\IdentityInterface
{
    public $leaf_id;
    public int $leaf_model; // 0:空白模式，1:普通模式
    public int $attendence_of_leaf; // 總人數
    public $leaf_type;
    public $file;
    // private static $leafs = [];

    public $founder_account, $founder_id;
    public $speaker_account;
    public int $speaker_num;
    public $manager_account;
    public int $manager_num;
    public $gardener_account, $gardener_id;

    public $uuid, $teamUUID, $appUUID, $createdAt, $roomToken;
    public $region;
    public $responseData, $responseData2, $appIdentifier;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'leaf';
    }

    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            [['founder_id'], 'required'],
            [['num_of_people'], 'int', 'max' => 200], //我先設定一場葉子最多200人
            // [['file'], 'file', 'skipOnEmpty' => false, 'extensions' => 'jpg, png, mp4, m4v, mov, qt, avi, flv, wmv, mkv'] // 圖片檔&錄影檔 副檔名
        ];
    }
    public static function findIdentity($leaf_id) //使用指定的葉子ID 查找其對應資料
    {
        return self::findOne($leaf_id);
    }
    /**
     * {@inheritdoc}
     */
    public static function findIdentityByAccessToken($token, $type = null)
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

    public function CatchLink()
    {
        // AppIdentifier
        $AppIdentifier = file_get_contents('/Users/Minna/library-api/library-api/library-api/AppIdentifier.txt');
        // $AppIdentifier = file_get_contents('C:/Users/user/桌面/api_file_test/fastboard/AppIdentifier.txt');
        // link
        $link = $this->link;
        // $link = "Someone sent you a link : NOT3ROOM_5937908356";
        // 判斷前端給的字串是否太短
        if ($true_link = substr($link, 26)) {
            // 確認開頭是對的
            $check_link_title = substr($link, 0, 26);
            if ($check_link_title != "Someone sent you a link : ") {
                return [
                    'error_message' => "你黃色部分格式錯了,去看api reference !"
                ];
            }
        } else {
            return [
                'error_message' => "Error! String is too short!"
            ];
        }
        // if link 匹配：取得uuid；if找不到：null
        if ((Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE link = '$true_link'")->queryOne()) != null) { // if找得到link
            $roomUUID = implode(Yii::$app->db->createCommand("SELECT uuid FROM leaf WHERE link  = '$true_link'")->queryOne());
            $roomToken = implode(Yii::$app->db->createCommand("SELECT roomToken FROM fastboard_create_room WHERE uuid = '$roomUUID'")->queryOne());
            // $appUUID = implode(Yii::$app->db->createCommand("SELECT appUUID FROM fastboard_create_room WHERE uuid = '$roomUUID'")->queryOne());
            $leaf_name = implode(Yii::$app->db->createCommand("SELECT leaf_name FROM leaf WHERE link  = '$true_link'")->queryOne());

            return [
                'roomUUID' => $roomUUID,
                'roomToken' => $roomToken,
                'appID' => $AppIdentifier,
                'leaf_name' => $leaf_name,
            ];
        } else { // if找不到link
            return [
                'error_message' => "Link not found !"
            ];
        }
    }

    public function saveVideo()
    {
        // file
        $name = $this->file->baseName; // 原本的名稱
        // time
        $initial_time = date('Y/m/d H:i:s');
        $real_time = date('Ymd-His', strtotime($initial_time) + 6 * 60 * 60);
        // 檔案格式    eg. txt, png
        $file_format = $this->file->extension;
        // new_name : 儲存的名字
        $new_name = $name . '_' . $real_time . '.' . $file_format;
        // file_path
        $file_path = '/Users/Minna/library-api/library-api/library-api/leaf錄影檔/' . $name . '_' . $real_time . '.' . $file_format;
        // $file_path = 'C:/Users/user/桌面/api_file_test/leaf錄影檔/' . $name . '_' . $real_time . '.' . $file_format;

        //save    一定要save,才會存在路徑
        $this->file->saveAs($file_path, false);

        //Video_file要存的位置，資料庫還沒新增
        //Video_file有打錯記得改
        Yii::$app->db->createCommand("UPDATE leaf SET video_file_name = '$new_name', video_file_path = '$file_path' WHERE uuid = '$this->leaf_id'")->execute();
        return [
            'message' => "儲存成功"
        ];
    }

    public function generateNormalLeaf() //new add，產生normal leaf的時候
    {
        // leaf_model
        $leaf_model = $this->leaf_model;
        // leaf_id
        $leaf_id = $this->uuid;
        // founder
        $founder_id = $this->founder_id;
        $founder_firstname = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id  = '$founder_id'")->queryOne());
        // speaker
        $speaker_acc = $this->speaker_account;
        // $speaker_num = sizeof($speaker_acc, 0);
        if ($speaker_acc == NULL) {
            return [
                'error_message' => "沒有演講者",
            ];
        }
        $speaker_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$speaker_acc'")->queryOne());
        $speaker_firstname = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id = '$speaker_id'")->queryOne());

        // num_of_people
        $manager_account = $this->manager_account;
        if ($manager_account == NULL) {
            return [
                'error_message' => "沒有管理者",
            ];
        } else {
            $manager_num = sizeof($manager_account, 0); // manager人數
            if ($manager_num > 3) {
                $manager_num = sizeof($manager_account, 0); // manager人數
                return [
                    'error_message' => "管理者數量超過上限",
                ];
            }
            //要防人數，這邊先判斷創始人跟演講者有沒有重疊
            else if($founder_id == $speaker_id){
                $num_of_people = 1 + $manager_num;
            }
            else{
                $num_of_people = 1 + 1 + $manager_num; // 初始總人數：創始人*1 + 演講者*1 + 管理者*n
            }
        }
       
        // link
        $randomNumber = mt_rand(1000000000, 9999999999); // 生成10位隨機數
        $randomNumberAsString = strval($randomNumber); //轉換type
        $link = 'NOT3ROOM_'.$randomNumberAsString;
        
        do{
            $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM leaf WHERE link = '$link'")->queryOne());
            // 此連結已存在
            if($num != 0){
                $link = 'NOT3ROOM_'.$randomNumberAsString;
            }
        }while($num != 0);

        // 寫入 leaf db
        if (Yii::$app->db->createCommand("INSERT INTO `leaf` (`uuid`,`founder_id`,`num_of_people`,`link`) VALUES ('$leaf_id', '$founder_id','$num_of_people','$link');")->execute()) {
            // 葉子中的人:創始人、演講者，寫入gardener_of_leaf db
            if (Yii::$app->db->createCommand("INSERT INTO `gardener_of_leaf` (`gardener_id`,`leaf_id`) VALUES ('$founder_id','$leaf_id');")->execute()) {
                if (Yii::$app->db->createCommand("INSERT INTO `gardener_of_leaf` (`gardener_id`,`leaf_id`) VALUES ('$speaker_id','$leaf_id');")->execute()) {
                    // 傳到Managerofleaf
                    $managerofleaf = new Managerofleaf();
                    $managerofleaf->leaf_id = $leaf_id;
                    $managerofleaf->manager_account = $manager_account;
                    $managerofleaf->manager_num = $manager_num;

                    // 傳到Normalleaf
                    $normalleaf = new Normalleaf();
                    $normalleaf->leaf_id = $leaf_id;
                    $normalleaf->leaf_type = $this->leaf_type; // leaf_type
                    $normalleaf->speaker_id = $speaker_id; // speaker_id
                    $normalleaf->file = $this->file; // file
                    //$normalleaf->generateUpload();

                    // 葉子中目前人數
                    // $attendence_of_leaf = 1 + $speaker_num + $manager_num; // 創始人+演講者+管理者
                    $attendence_of_leaf = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM gardener_of_leaf WHERE leaf_id = '$leaf_id'")->queryOne());
                    $managers = $managerofleaf->generateManager();
                    $manager_ids = $managers['manager_id'];
                    // return $manager_ids;
                    for($i = 0; $i < $manager_num; $i++){
                        //如果管理者和創始人重疊
                        if($manager_ids[$i] == $speaker_id){
                            $num_of_people --;
                        }
                        //或演講者重疊(可能三者重疊)
                        if($manager_ids[$i] == $founder_id){
                            $num_of_people --;
                        }
                    }
                    return [
                        "leafData" => [
                            'link' => $link,
                            'founder_firstname' => $founder_firstname,
                            'speaker_firstname' => $speaker_firstname,
                            "管理者" => $managers['manager_firstname'],
                            "不要理它" => $normalleaf->generateNormalleaf()
                            // 'attendence_of_leaf' => $attendence_of_leaf
                        ],
                        "roomData" => $this->responseData,
                        "roomToken" => $this->responseData2,
                        "appIdentifier" => $this->appIdentifier
                    ];
                } else {
                    return [
                        'error_message' => "沒存到db：gardener_of_leaf",
                    ];
                }
            } else {
                return [
                    'error_message' => "沒存到db：gardener_of_leaf",
                ];
            }
        } else {
            return [
                'error_message' => "沒存到db：leaf",
            ];
        }
    }
        
    public function generateWhiteLeaf() //new add，產生white leaf的時候
    {
        // leaf_model
        $leaf_model = $this->leaf_model;
        $leaf_name = $this->leaf_name;
        // founder
        $founder_id = $this->founder_id;
        $founder_firstname = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id  = '$founder_id'")->queryOne());

        // leaf_id
        $leaf_id = $this->uuid;
        // num_of_people
        $num_of_people = 1; // 創始人*1
        // link
        $randomNumber = mt_rand(1000000000, 9999999999); // 生成10位隨機數
        $randomNumberAsString = strval($randomNumber); //轉換type
        $link = 'NOT3ROOM_' . $randomNumberAsString;

        do {
            $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM leaf WHERE link = '$link'")->queryOne());
            // 此連結已存在
            if ($num != 0) {
                $link = 'NOT3ROOM_' . $randomNumberAsString;
            }
        } while ($num != 0);

        // 無管理者，寫入 leaf db
        if (Yii::$app->db->createCommand("INSERT INTO `leaf` (`uuid`,`leaf_name`,`founder_id`,`num_of_people`,`link`) VALUES ('$leaf_id', '$leaf_name', '$founder_id','$num_of_people','$link');")->execute()) {
            // 葉子中人數，寫入 gardener_of_leaf db
            if (Yii::$app->db->createCommand("INSERT INTO `gardener_of_leaf` (`gardener_id`,`leaf_id`) VALUES ('$founder_id','$leaf_id');")->execute()) {
                // 葉子中目前人數
                $attendence_of_leaf = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM gardener_of_leaf WHERE leaf_id = '$leaf_id'")->queryOne());

                return [
                    "leafData" => [
                        'link' => $link,
                        'founder_firstname' => $founder_firstname,
                        // 'attendence_of_leaf' => $attendence_of_leaf
                    ],
                    "roomData" => $this->responseData,
                    "roomToken" => $this->responseData2,
                    "appIdentifier" => $this->appIdentifier
                ];
            } else {
                return "沒存到db：gardener_of_leaf";
            }
        } else {
            return "沒存到db：leaf";
        }
    }

    public function showGardenerFile()
    {
        // gardener_account
        $gardener_account = $this->gardener_account;
        // leaf_id
        $leaf_id = $this->leaf_id;
        $gardener_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$gardener_account'")->queryOne());
        // 從server的哪裡下載
        $file_path = implode(Yii::$app->db->createCommand("SELECT gardener_file_path FROM `gardener_of_leaf` WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->queryOne());
        // file_name
        $file_name = implode(Yii::$app->db->createCommand("SELECT gardener_file_name FROM `gardener_of_leaf` WHERE leaf_id = '$leaf_id' AND gardener_id = '$gardener_id'")->queryOne());
        // download file
        $response_file = Yii::$app->response->sendFile($file_path, $file_name);

        return [
            // 'leaf_id' => $leaf_id,
            // 'gardener_account' => $gardener_account,
            'file' => $response_file
        ];
    }
    public function isTrue()
    {
        $is_uuid = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM leaf WHERE uuid = '$this->uuid'")->queryOne());
        //房間存在
        if ($is_uuid) {
            $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM leaf WHERE uuid = '$this->uuid' AND founder_id = '$this->founder_id'")->queryOne());
            $last = implode(Yii::$app->db->createCommand("SELECT num_of_people FROM `leaf` WHERE uuid = '$this->uuid'")->queryOne());
            if ($num) { // 是房間創始人
                return 1;
            } elseif ($last == '0') { // 是最後一人
                return 1;
            } else {
                return "沒有權限關閉房間";
            }
        } else {
            return "房間不存在";
        }
    }
}
