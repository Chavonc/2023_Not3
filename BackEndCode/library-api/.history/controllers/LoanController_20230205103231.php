<?php

namespace app\controllers;

use Yii;
use app\models\Loan;

class LoanController extends \yii\web\Controller
{
    // To allow the API to handle POST requests, CSRF validation will be disabled
    public $enableCsrfValidation = false;

    public function actionIndex()
    {
        return $this->render('index');
    }

    public function actionIndex()
    {
        $loans = Loan::find()->all();
        return $this->asJson($loans);
    }
    private function errorResponse($message)
    {

        // set response code to 400
        Yii::$app->response->statusCode = 400;

        return $this->asJson(['error' => $message]);
    }
    
    public function markAsBorrowed()
    {
        $this->is_available_for_loan = (int)false;
        $this->save();
    }
}
