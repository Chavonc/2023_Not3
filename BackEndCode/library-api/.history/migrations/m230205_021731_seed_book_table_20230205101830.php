<?php

use yii\db\Migration;

/**
 * Class m230205_021731_seed_book_table
 */
class m230205_021731_seed_book_table extends Migration
{
    /**
     * {@inheritdoc}
     */
    public function safeUp()
    {
        $this->insertFakeBooks();
    }

    /**
     * {@inheritdoc}
     */
    public function safeDown()
    {
        echo "m230205_021731_seed_book_table cannot be reverted.\n";

        return false;
    }

    /*
    // Use up()/down() to run migration code without a transaction.
    public function up()
    {

    }

    public function down()
    {
        echo "m230205_021731_seed_book_table cannot be reverted.\n";

        return false;
    }
    */
}
