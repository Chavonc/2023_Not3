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
    private function insertFakeMembers() 
    {
            $faker = \Faker\Factory::create();
    
            for ($i = 0; $i < 10; $i++) {
                $this->insert(
                    'member',
                    [
                        'name' => $faker->name
                    ]
                );
            }
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
