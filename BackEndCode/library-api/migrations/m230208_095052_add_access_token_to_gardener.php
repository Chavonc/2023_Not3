<?php

use yii\db\Migration;

/**
 * Class m230208_095052_add_access_token_to_gardener
 */
class m230208_095052_add_access_token_to_gardener extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->addColumn('gardener', 'access_token', $this->string());
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        $this->dropColumn('gardener', 'access_token');
    }

    /*
    // Use up()/down() to run migration code without a transaction.
    public function up()
    {

    }

    public function down()
    {
        echo "m230208_095052_add_access_token_to_gardener cannot be reverted.\n";

        return false;
    }
    */
}
