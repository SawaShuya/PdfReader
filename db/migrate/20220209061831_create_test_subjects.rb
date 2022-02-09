class CreateTestSubjects < ActiveRecord::Migration[5.2]
  def change
    create_table :test_subjects do |t|
      t.integer :test_number_id, null: false
      t.integer :subject_id, null: false

      t.timestamps
    end
  end
end
