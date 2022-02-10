class TestSubject < ApplicationRecord
  has_many :questions
  belongs_to :subject
  belongs_to :test_number


  def full_info
    test_number.year.to_s + "年 第 " + test_number.number.to_s + " 回 " + subject.name
  end
end
