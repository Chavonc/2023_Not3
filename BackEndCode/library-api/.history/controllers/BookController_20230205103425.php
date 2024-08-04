<?php

namespace app\controllers;

class BookController extends \yii\rest\ActiveController
{
    public $modelClass = 'app\models\Book';
    
    public function actionIndex()
    {
        return $this->render('index');
    }
    
    public function markAsBorrowed()
    {
        $this->is_available_for_loan = (int)false;
        $this->save();
    }
}
