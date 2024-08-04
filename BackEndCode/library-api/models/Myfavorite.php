<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;

class MyFavorite extends \yii\db\ActiveRecord
{
    public $leaf_id;
    public $adder_account;
    public $added_account;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'my_favorite';
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

    public function generateMyFavorite() // A把B加入我的最愛
    {
        //拿account 算id  
        //name寫入db

        // leaf_id
        $leaf_id = $this->leaf_id;

        // A
        $adder_account = $this->adder_account;
        $adder_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$adder_account'")->queryOne());

        // B
        $added_account = $this->added_account;
        $added_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$added_account'")->queryOne());

        // 寫入db
        Yii::$app->db->createCommand("INSERT INTO `my_favorite` (`leaf_id`,`gardener_id`,`favorite_gardener_id`) VALUES ('$leaf_id', '$adder_id','$added_id');")->execute();

        return [
            'leaf_id' => $leaf_id,
            'adder_account' => $adder_account,
            'added_account' => $added_account
        ];
    }
    public function showMyFavorite(){
        $result = Yii::$app->db->createCommand("SELECT * FROM my_favorite WHERE gardener_id = '$this->adder_account'")
        ->queryOne();
        return $result;
    }
}