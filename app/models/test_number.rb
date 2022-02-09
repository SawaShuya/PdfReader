class TestNumber < ApplicationRecord
  has_many :test_subjects
  has_many :subjects, through: :test_subjects
end
