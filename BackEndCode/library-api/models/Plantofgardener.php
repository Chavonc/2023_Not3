<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;

class PlantOfGardener extends \yii\db\ActiveRecord
{
    public $gardener_id;
    public $plant_name;
    public $plant_type;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'plant_of_gardener';
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
    
    public function generatePlant()
    {
        // 園丁id
        $gardener_id = $this->gardener_id;
        // tree_name
        $tree_name = $this->plant_name;
        // 確認 tree name 是否已存在
        $check_repeat = Yii::$app->db->createCommand("SELECT gardener_id FROM `plant_of_gardener` WHERE gardener_id = '$gardener_id' AND tree_name = '$tree_name'")->queryOne();
        if ($check_repeat != NULL) { // 已存在，不可創建
            return [
                'error_message' => "tree name 已存在!"
            ];
        } else {
            // plant種類id
            $plant_type = $this->plant_type;
            // return $plant_type;
            $plant_id = Yii::$app->db->createCommand("SELECT plant_id FROM plant WHERE plant_name = '$plant_type'")->queryOne();
            if ($plant_id != null) {
                $plant_id = implode(Yii::$app->db->createCommand("SELECT plant_id FROM plant WHERE plant_name = '$plant_type'")->queryOne());
                // plant圖片
                if ($plant_picture_Path = implode(Yii::$app->db->createCommand("SELECT plant_picture_path FROM plant WHERE plant_id = '$plant_id'")->queryOne())) {
                    if (Yii::$app->db->createCommand("INSERT INTO `plant_of_gardener` (`gardener_id`,`tree_name`,`plant_id`) VALUES ('$gardener_id', '$tree_name', '$plant_id')")->execute()) {
                        return [
                            'message' => "創建成功!",
                            'plant_picture_Path' => $plant_picture_Path
                        ];
                    } else {
                        return [
                            'error_message' => "創建失敗!"
                        ];
                    }
                } else {
                    return [
                        'error_message' => "Cannot found plant picture path!"
                    ];
                }
            } else {
                return [
                    'error_message' => "Plant type not found!"
                ];
            }
        }
    }

    public function returnAllPlant()
    {
        // 園丁id
        $gardener_id = $this->gardener_id;
        // save result 用的 array
        $return_tree_name = array();
        // tree_name
        $num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM plant_of_gardener WHERE gardener_id = '$gardener_id'")->queryOne());
        if ($num != "0") {
            for ($i = 0; $i < $num; $i++) {
                $tree_name = implode(Yii::$app->db->createCommand("SELECT tree_name FROM plant_of_gardener WHERE gardener_id = '$gardener_id' LIMIT $i,1")->queryOne());
                array_push($return_tree_name, "$tree_name");
            }
            return [
                'plant_num' => $num,
                'plant_name' => $return_tree_name
            ];
        } else { // 該園丁沒有plant
            return [
                'error_message' => "No plant !"
            ];
        }
    }
}
