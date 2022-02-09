class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.integer :test_subject_id, null: false
      t.string :text, null: false
      t.string :choice1, null: false
      t.string :choice2, null: false
      t.string :choice3, null: false
      t.string :choice4, null: false
      t.string :choice5, null: false
      t.string :attention, null: true
      
      t.string :answer, null: true
      t.text :comment, null: true
      t.timestamps
    end
  end
end
