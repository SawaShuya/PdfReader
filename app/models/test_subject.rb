class TestSubject < ApplicationRecord
  has_many :questions
  belongs_to :subject
  belongs_to :test_number
end
