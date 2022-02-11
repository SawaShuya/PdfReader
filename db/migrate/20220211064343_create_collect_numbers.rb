class CreateCollectNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :collect_numbers do |t|
      t.integer :question_id, null: false
      t.integer :number, null: false
      t.timestamps
    end
  end
end
