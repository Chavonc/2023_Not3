<?php

namespace app\models;

use Yii;
use yii\base\NotSupportedException;
use yii\behaviors\TimestampBehavior;
use yii\db\ActiveRecord;
use yii\web\IdentityInterface;
use yii\base\Model;

class Reportrecord extends \yii\db\ActiveRecord
{
    public $leaf_id;
    public $respondent_account;
    public $whistleblower_account;

    /**
     * {@inheritdoc}
     */
    public static function tableName()
    {
        return 'reportrecord';
    }

    /**
     * {@inheritdoc}
     */
    // public function rules()
    // {
    //     return [
    //         [['leaf_id', 'respondent_account', 'whistleblower_account'], 'required']
    //     ];
    // }

    public function generateReport() //new add，舉報的時候
    {
        //拿account 算id  id寫入db

        // 被舉報的人
        $respondent_acc = $this->respondent_account;
        $respondent_id = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$respondent_acc'")->queryScalar();

        // 舉報的人
        $whistleblower_acc = $this->whistleblower_account;
        $whistleblower_id = Yii::$app->db->createCommand("SELECT gardener_id FROM gardener WHERE account = '$whistleblower_acc'")->queryScalar();

        // report_time
        $initial_time = date('Y/m/d H:i:s');
        $report_time = date('Y/m/d H:i:s', strtotime($initial_time) + 6 * 60 * 60);

        // leaf_id
        $leaf_id = $this->leaf_id;

        // 寫入db
        Yii::$app->db->createCommand("INSERT INTO `report_record` (`whistleblower_id`,`respondent_id`,`report_time`,`leaf_id`) VALUES ('$whistleblower_id', '$respondent_id', '$report_time','$leaf_id');")->execute();

        return [
            'leaf_id' => $leaf_id
        ];
    }

}