<?php

namespace app\controllers;

use Yii;
use yii\rest\ActiveController;
use yii\filters\auth\CompositeAuth;
use yii\filters\auth\HttpBasicAuth;
use yii\filters\auth\HttpBearerAuth;
use yii\filters\auth\QueryParamAuth;

//BaseController先繼承了ActiveController
class BaseController extends ActiveController
{
    public $modelClass = 'app\models\AccessToken';
    public function behaviors()
    {
        $behaviors = parent::behaviors();
        $behaviors['authenticator'] = [ // authMethods 中每个单元应为一个认证方法名或配置数组
            'class' => CompositeAuth::class, //这个地方使用`ComopositeAuth` 混合认证
            'authMethods' => [//`authMethods` 中的每一个元素都应该是 一种 认证方式的类或者一个 配置数组
                HttpBasicAuth::class,
                HttpBearerAuth::class,
                QueryParamAuth::class,
            ],
        ];
        return $behaviors;
    }
}