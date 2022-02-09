class Subject < ApplicationRecord
  has_many :test_subjects
  has_many :test_numbers, through: :test_subjects

end
