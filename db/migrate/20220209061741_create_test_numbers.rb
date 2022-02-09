class CreateTestNumbers < ActiveRecord::Migration[5.2]
  def change
    create_table :test_numbers do |t|
      t.integer :number, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
