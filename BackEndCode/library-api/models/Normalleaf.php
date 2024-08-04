<?php
//對比過了，合併完畢
namespace app\models;


use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;


class Normalleaf extends \yii\db\ActiveRecord
{
    public $leaf_id;
    public $leaf_type;
    public $speaker_id;
    public $file;
    public $baseName = null;


    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'normal_leaf';
    }


    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            // [['founder_id', 'speaker_id'], 'required'],
            // [['num_of_people'], 'int', 'max' => 200], //我先設定一場葉子最多200人
            // [['file'], 'file', 'skipOnEmpty' => false, 'extensions' => 'pdf, ppt, pptx']


        ];
    }


    // public static function findLeafid($leaf_id) //使用指定的用户 ID 查找身份类的实例
    // {
    //     // return isset(self::$gardeners[$id]) ? new static(self::$gardeners[$id]) : null; //存在就會返回其ID用戶資料，不存在返回Null
    //     $result = Yii::$app->db->createCommand("SELECT * FROM access_token WHERE leaf_id = '$leaf_id'")
    //         ->queryOne();
    //     return new static($result);
    //     // return static::findOne($id); //原本的
    // }


    public function generateNormalleaf() //new add，產生normal_leaf的時候
    {
        // leaf_id
        $leaf_id = $this->leaf_id;
        // leaf_type
        $leaf_type = $this->leaf_type;
        // $baseName = $this->baseName;
        // if ($this->file->baseName != $baseName) { // 沒給file 防呆
        //     return [
        //         'error_message' => "No file."
        //     ];
        // }
        if ($leaf_type_id = implode(Yii::$app->db->createCommand("SELECT leaf_type_id FROM leaf_type WHERE leaf_type_name = '$leaf_type'")->queryOne())) {
            // speaker_id
            $speaker_id = $this->speaker_id;
            // ppt file
            $name = $this->file->baseName; // 原本的名稱
            // time
            $initial_time = date('Y/m/d H:i:s');
            $real_time = date('Ymd-His', strtotime($initial_time) + 6 * 60 * 60);
            // 檔案格式    eg. txt, png
            $file_format = $this->file->extension;
            // new_name : 儲存的名字
            $ppt_new_name = $name . '_' . $real_time . '.' . $file_format;
            // file_path
            $ppt_file_path = '/Users/Minna/library-api/library-api/library-api/normal_leaf_speaker_ppt/' . $name . '_' . $real_time . '.' . $file_format;
            // $ppt_file_path = 'C:/Users/user/桌面/api_file_test/speaker_ppt/' . $name . '_' . $real_time . '.' . $file_format;
            // $ppt_file_path = 'C:/xampp/htdocs/library-api/library-api/normal_leaf_speaker_ppt/' . $name . '_' . $real_time . '.' . $file_format;


            //save    一定要save,才會存在路徑
            if ($this->file->saveAs($ppt_file_path, false)) {
                // 寫入db
                if (Yii::$app->db->createCommand("INSERT INTO `normal_leaf` (`leaf_type_id`, `leaf_id`, `leaf_file_name`, `leaf_file_path`,`speaker_id`) VALUES ('$leaf_type_id','$leaf_id','$ppt_new_name','$ppt_file_path','$speaker_id');")->execute()) {
                    // success 不用回傳東西
                } else {
                    return [
                        'error_message' => "沒存到db：normal_leaf"
                    ];
                }
            } else {
                return [
                    'error_message' => "ppt儲存失敗"
                ];
            }
        } else {
            return [
                'error_message' => "leaf_type錯誤"
            ];
        }
    }
}
