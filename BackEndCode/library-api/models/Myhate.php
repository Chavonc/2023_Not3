<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;

class MyHate extends \yii\db\ActiveRecord
{
    public $leaf_id;
    public $adder_account;
    public $added_account;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'my_hate';
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

    public function generateMyHate() // A把B屏蔽
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
        Yii::$app->db->createCommand("INSERT INTO `my_hate` (`leaf_id`,`gardener_id`,`hated_gardener_id`) VALUES ('$leaf_id', '$adder_id','$added_id');")->execute();

        return [
            'leaf_id' => $leaf_id,
            'adder_account' => $adder_account,
            'added_account' => $added_account
        ];
    }
}