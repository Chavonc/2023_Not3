<?php
$acc_exists = Yii::$app->db->createCommand("SELECT COUNT(account) FROM gardener WHERE account = '$account'")	
            ->queryOne();	
        return $acc_exists;