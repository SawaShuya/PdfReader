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

      t.string :answer1
      t.string :answer2
      t.string :answer3
      t.string :answer4
      t.string :answer5
      
      t.text :comment, null: true
      t.timestamps
    end
  end
end
