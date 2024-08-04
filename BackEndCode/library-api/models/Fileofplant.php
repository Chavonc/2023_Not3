<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;

class FileOfPlant extends \yii\db\ActiveRecord
{
    public $gardener_id;
    public $leaf_id;
    public $plant_name;
    public $fruit_num;
    public $fileName, $filePath;
    public $file_name;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'file_of_plant';
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

    public function returnAllFile()
    {
        // 園丁id
        $gardener_id = $this->gardener_id;
        // plant_name
        $tree_name = $this->plant_name;
        // 確認plant是否存在
        $check_plant_exist = Yii::$app->db->createCommand("SELECT gardener_id FROM `plant_of_gardener` WHERE gardener_id = '$gardener_id' AND tree_name = '$tree_name'")->queryOne();
        if ($check_plant_exist == NULL) { // 不存在
            return [[
                'error_message' => "tree不存在!"
            ]];
        }
        // plant_of_gardener_id
        $plant_of_gardener_id = implode(Yii::$app->db->createCommand("SELECT plant_of_gardener_id FROM plant_of_gardener JOIN gardener ON gardener.gardener_id = plant_of_gardener.gardener_id WHERE gardener.gardener_id = '$gardener_id' AND plant_of_gardener.tree_name = '$tree_name'")->queryOne());

        // fruit_num
        $fruit_num = $this->fruit_num;
        $check_fruit_num = Yii::$app->db->createCommand("SELECT file_of_plant_number FROM `file_of_plant` WHERE plant_of_gardener_id = '$plant_of_gardener_id' AND file_of_plant_number = '$fruit_num'")->queryOne();
        if ($check_fruit_num == NULL) { // 不存在
            return [[
                'error_message' => "Fruit_num error!"
            ]];
        }

        $fileName = implode(Yii::$app->db->createCommand("SELECT file_of_plant_name FROM file_of_plant WHERE plant_of_gardener_id = '$plant_of_gardener_id' AND file_of_plant_number = '$fruit_num'")->queryOne());
        // return $fileName;
        $filePath = implode(Yii::$app->db->createCommand("SELECT file_of_plant_path FROM file_of_plant WHERE plant_of_gardener_id = '$plant_of_gardener_id' AND file_of_plant_number = '$fruit_num'")->queryOne());
        // return $filePath;
        return Yii::$app->response->sendFile($filePath, $fileName);
    }

    public function showFruitInfo()
    {
        // 園丁id
        $gardener_id = $this->gardener_id;
        // plant_name
        $tree_name = $this->plant_name;

        // 確認plant是否存在
        $check_plant_exist = Yii::$app->db->createCommand("SELECT gardener_id FROM `plant_of_gardener` WHERE gardener_id = '$gardener_id' AND tree_name = '$tree_name'")->queryOne();
        if ($check_plant_exist == NULL) { // 不存在
            return [[
                'error_message' => "tree不存在!"
            ]];
        }

        // 存結果
        $return_fruit_info = [];
        //該plant中所有fruit的名字
        $fruit_result = Yii::$app->db->createCommand("SELECT file_of_plant_number,file_of_plant_name FROM file_of_plant JOIN plant_of_gardener ON file_of_plant.plant_of_gardener_id = plant_of_gardener.plant_of_gardener_id WHERE tree_name = '$tree_name' AND gardener_id = $gardener_id;")->queryAll();
        foreach ($fruit_result as $row) {
            $return_fruit_info[] = [
                'gardener_id' => $gardener_id,
                'plant_name' => $tree_name,
                'fruit_num' => $row['file_of_plant_number'],
                'fruit_name' => $row['file_of_plant_name']
            ];
        }

        $fruit_num = implode(Yii::$app->db->createCommand("SELECT num_of_fruit FROM `plant_of_gardener` WHERE gardener_id = '$gardener_id' AND tree_name = '$tree_name';")->queryOne());

        return [[
            'total_fruit_num' => "$fruit_num",
            'fruit_info' => $return_fruit_info
        ]];
    }

    public function showPlantPicture()
    {
        $gardener_id = $this->gardener_id;
        $plant_name = $this->plant_name;
        // SELECT * FROM `plant_of_gardener` WHERE tree_name = '工作' AND gardener_id = '55';
        if (Yii::$app->db->createCommand("SELECT * FROM `plant_of_gardener` WHERE tree_name = '$plant_name' AND gardener_id = '$gardener_id'")->queryOne()) {
            $filePath = implode(Yii::$app->db->createCommand("SELECT plant_picture_path FROM plant JOIN plant_of_gardener ON plant.plant_id = plant_of_gardener.plant_id WHERE tree_name = '$plant_name' AND gardener_id = '$gardener_id'")->queryOne());
            $fileName = implode(Yii::$app->db->createCommand("SELECT plant_picture_name FROM plant JOIN plant_of_gardener ON plant.plant_id = plant_of_gardener.plant_id WHERE tree_name = '$plant_name' AND gardener_id = '$gardener_id'")->queryOne());

            return  Yii::$app->response->sendFile($filePath, $fileName);
        } else {
            return [[
                'error_message' => "Plant not found!"
            ]];
        }
    }

    public function addOneFile()
    {
        $gardener_id = $this->gardener_id;
        // gardener first name
        $gardener_first_name = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id = '$gardener_id'")->queryOne());
        // leaf_id
        $leaf_id = $this->leaf_id;
        // 植物id
        $plant_name = $this->plant_name;
        $check_plant = Yii::$app->db->createCommand("SELECT plant_of_gardener_id FROM `plant_of_gardener` WHERE gardener_id = '$gardener_id' AND tree_name = '$plant_name'")->queryOne();
        if ($check_plant == null) {
            return [
                'error_message' => "找不到plant!"
            ];
        }
        // return $plant_of_gardener_id;
        $plant_of_gardener_id = implode(Yii::$app->db->createCommand("SELECT plant_of_gardener_id FROM `plant_of_gardener` WHERE gardener_id = '$gardener_id' AND tree_name = '$plant_name'")->queryOne());

        //算此園丁此樹目前已有幾個fruit
        $fruit_num = implode(Yii::$app->db->createCommand("SELECT COUNT(*) FROM file_of_plant WHERE plant_of_gardener_id = '$plant_of_gardener_id'")->queryOne());

        // leaf name
        $leaf_name = implode(Yii::$app->db->createCommand("SELECT leaf_name FROM `leaf` WHERE uuid = '$leaf_id'")->queryOne());

        // file
        $file_type = ".pptx";
        $filePath = $this->filePath;
        $initial_time = date('Y/m/d H:i:s');
        $new_time = date('YmdHis', strtotime($initial_time) + 6 * 60 * 60);
        $new_fileName = $this->file_name . "_" . $gardener_id . "_" . $new_time . $file_type;
        $new_filePath = '/Users/Minna/library-api/library-api/library-api/fruits/' . $new_fileName;
        // $new_filePath = 'C:/Users/user/桌面/api_file_test/最終筆記檔案/' . $new_fileName;
        // return [
        //     'leaf_name' => "$leaf_name",
        //     'new_fileName' => "$new_fileName"
        // ];
        // 找num_of_fruit
        $num_of_fruit = implode(Yii::$app->db->createCommand("SELECT num_of_fruit FROM `plant_of_gardener` WHERE plant_of_gardener_id = '$plant_of_gardener_id'")->queryOne());
        $new_num_of_fruit = $num_of_fruit + 1;

        if (rename($filePath, $new_filePath)) {
            $result = Yii::$app->db->createCommand("INSERT INTO file_of_plant (plant_of_gardener_id, file_of_plant_name, file_of_plant_path, file_of_plant_number) VALUES ('$plant_of_gardener_id','$new_fileName','$new_filePath',$fruit_num + 1);")->execute();
            Yii::$app->db->createCommand("UPDATE `plant_of_gardener` SET num_of_fruit = '$new_num_of_fruit' WHERE plant_of_gardener_id = '$plant_of_gardener_id'")->execute();
            // UPDATE `plant_of_gardener` SET num_of_fruit = '1' WHERE plant_of_gardener_id = '30';
            return [
                'message' => "採收成功!"
                // "gardener_id" => $gardener_id,
                // "uuid" => $leaf_id,
                // "filePath" => $new_filePath,
                // "leaf_name" => $leaf_name
            ];
        } else {
            return [
                'error_message' => "檔案移動失敗!"
            ];
        }
    }

    public function showRiv()
    {
        $gardener_id = $this->gardener_id;
        $plant_name = $this->plant_name;
        // SELECT * FROM `plant_of_gardener` WHERE tree_name = '工作' AND gardener_id = '55';
        if (Yii::$app->db->createCommand("SELECT * FROM `plant_of_gardener` WHERE tree_name = '$plant_name' AND gardener_id = '$gardener_id'")->queryOne()) {
            $fileName = implode(Yii::$app->db->createCommand("SELECT riv_picture_name FROM plant JOIN plant_of_gardener ON plant.plant_id = plant_of_gardener.plant_id WHERE tree_name = '$plant_name' AND gardener_id = '$gardener_id'")->queryOne());
            $plant_type = implode(Yii::$app->db->createCommand("SELECT plant_name FROM plant JOIN plant_of_gardener ON plant.plant_id = plant_of_gardener.plant_id WHERE tree_name = '$plant_name' AND gardener_id = '$gardener_id'")->queryOne());
            return [[
                'file_name' => "$fileName",
                'plant_type' => "$plant_type"
            ]];
        } else {
            return [[
                'error_message' => "Plant not found!"
            ]];
        }
    }
}
