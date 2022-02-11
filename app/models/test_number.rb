class TestNumber < ApplicationRecord
  has_many :test_subjects, dependent: :destroy
  has_many :subjects, through: :test_subjects

  def display
    "第 " + number.to_s + " 回"
  end
end
