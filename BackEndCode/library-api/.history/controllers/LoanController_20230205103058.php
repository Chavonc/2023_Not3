<?php

namespace app\controllers;

use app\models\Loan;

class LoanController extends \yii\web\Controller
{
    // To allow the API to handle POST requests, CSRF validation will be disabled
    public $enableCsrfValidation = false;

    public function actionIndex()
    {
        return $this->render('index');
    }
}
