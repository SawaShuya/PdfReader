class Question < ApplicationRecord
  belongs_to :test_subject

  validates :text, presence: true
  validates :choice1, presence: true
  validates :choice2, presence: true
  validates :choice3, presence: true
  validates :choice4, presence: true
  validates :choice5, presence: true


  def fulltext
    fulltext = [text, choice1, choice2, choice3, choice4, choice5].compact
    fulltext.join
  end
end
