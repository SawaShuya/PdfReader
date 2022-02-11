class Question < ApplicationRecord
  belongs_to :test_subject
  has_many :collect_numbers, dependent: :destroy

  validates :text, presence: true
  validates :choice1, presence: true
  validates :choice2, presence: true
  validates :choice3, presence: true
  validates :choice4, presence: true
  validates :choice5, presence: true

  # attr_accessor :collect_answer1, :collect_answer2, :collect_answer3, :collect_answer4, :collect_answer5

  def fulltext
    fulltext = [text, choice1, choice2, choice3, choice4, choice5].compact
    fulltext.join
  end

  def update_collect_numbers(collect_answers)
    collect_answers.each_with_index do |answer, index|
      if answer == "1"
        collect_numbers.find_or_create_by(number: index + 1)
      else
        collect_number = collect_numbers.find_by(number: index + 1)
        collect_number.destroy if collect_number.present?
      end
    end
  end

  def check_collect(num)
    collect_numbers.pluck(:number).include?(num)
  end

  def self.search(word)
    if word.present?
      Question.where("text LIKE ?", "%#{word}%").includes(:test_subject)
    else
      Question.all.includes(:test_subject)
    end
  end

  def collect_answer1
    collect_numbers = self.set_collect_numbers
    @collect_answer1 = true if collect_numbers.include?(1)
  end
  def collect_answer2
    collect_numbers = self.set_collect_numbers
    @collect_answer2 = true if collect_numbers.include?(2)
  end
  def collect_answer3
    collect_numbers = self.set_collect_numbers
    @collect_answer3 = true if collect_numbers.include?(3)
  end
  def collect_answer4
    collect_numbers = self.set_collect_numbers
    @collect_answer4 = true if collect_numbers.include?(4)
  end
  def collect_answer5
    collect_numbers = self.set_collect_numbers
    @collect_answer5 = true if collect_numbers.include?(5)
  end

  def set_collect_numbers
    self.collect_numbers.pluck(:number)
  end
end
