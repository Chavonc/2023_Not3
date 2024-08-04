<?php

namespace app\controllers;

class LoanController extends \yii\web\Controller
{
    public $enableCsrfValidation = false;
    
    public function actionIndex()
    {
        return $this->render('index');
    }

}
