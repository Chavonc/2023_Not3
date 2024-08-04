<?php

use yii\db\Migration;

/**
 * Class m230205_021720_seed_member_table
 */
class m230205_021720_seed_member_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->insertFakeMembers();
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        echo "m230205_021720_seed_member_table cannot be reverted.\n";

        return false;
    }

    /*
    // Use up()/down() to run migration code without a transaction.
    public function up()
    {

    }

    public function down()
    {
        echo "m230205_021720_seed_member_table cannot be reverted.\n";

        return false;
    }
    */
}
