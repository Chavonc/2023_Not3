<?php
namespace app\models;


use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;


class Managerofleaf extends \yii\db\ActiveRecord
{
    public $leaf_id;
    public $manager_account;
    public $manager_num;


    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'manager_of_leaf';
    }


    /**
     * {@inheritdoc}
     */
    public function rules()
    {
        return [
            // [['founder_id', 'speaker_id'], 'required'],
            // [['num_of_people'], 'int', 'max' => 200], //我先設定一場葉子最多200人
        ];
    }
    // manager_account = ["B0929003","B0929077"]
    // array_slice($a, 1, 2);    // 从数组$a的第二个元素开始取出，并仅返回两个元素。
    // int sizeof(array，mode);


    public function generateManager()
    {
        $leaf_id = $this->leaf_id;
        $manager_acc = $this->manager_account; //all manager
        $manager_num = $this->manager_num;

        // save result用
        $return_manager_firstname = array();
        $return_manager_id = array();


        for ($i = 0; $i < $manager_num; $i++) {
            // return [
            //     'manager_num。。。。。' => $manager_num,
            //     // 'leaf_id' => $leaf_id
            // ];
            //$now_manager_acc = array_slice($manager_acc, $i, 1);
            $now_manager_acc = $manager_acc[$i];
            $manager_id = implode(Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$now_manager_acc'")->queryOne());
            $manager_firstname = implode(Yii::$app->db->createCommand("SELECT first_name FROM gardener WHERE gardener_id  = '$manager_id'")->queryOne());
            array_push($return_manager_firstname, "$manager_firstname");
            array_push($return_manager_id, "$manager_id");
            // 寫入db
            if (Yii::$app->db->createCommand("INSERT INTO `manager_of_leaf` (`manager_id`,`leaf_id`) VALUES ('$manager_id','$leaf_id');")->execute()) {
                if (Yii::$app->db->createCommand("INSERT INTO `gardener_of_leaf` (`gardener_id`,`leaf_id`) VALUES ('$manager_id','$leaf_id');")->execute()) {
                    // success 不用做事
                } else {
                    return [
                        'error_message' => "沒存到db：gardener_of_leaf",
                    ];
                }
            } else {
                return [
                    'error_message' => "沒存到db：manager_of_leaf",
                ];
            }
        }
        return [
            'manager_firstname' => $return_manager_firstname,
            'manager_id' => $return_manager_id,
            // 'leaf_id' => $leaf_id
        ];
    }
}
