<?php
// 一整個.php檔案是 new add
/**
 * 在这里配置所有的路由规则
 */
$urlRuleConfigs = [
    [
        'controller' => 'gardener',
        'extraPatterns' => [
            'POST login' => 'login',
            'GET signup-test' => 'signup-test',
        ],
    ],
];
/**
 * 基本的url规则配置
 */
function baseUrlRules($unit)
{
    $config = [
        'class' => 'yii\rest\UrlRule',
    ];
    return array_merge($config, $unit);
}
return array_map('baseUrlRules', $urlRuleConfigs);