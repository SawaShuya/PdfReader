class QuestionCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  COLLECTION_NUM = 5 

  attr_accessor :collection

  def initialize(attributes = [])
    if attributes.present?
      self.collection = attributes.map do |value|
        Question.new(
          test_subject_id: value['test_subject_id'],
          text: value['text'],
          choice1: value['choice1'],
          choice2: value['choice2'],
          choice3: value['choice3'],
          choice4: value['choice4'],
          choice5: value['choice5'],
          attention: value['attention'],
        )
      end
    else
      self.collection = COLLECTION_NUM.times.map{ Question.new }
    end
  end

  # レコードが存在するか確認するメソッド
  def persisted?
    false
  end

  def save
    is_success = true
    ActiveRecord::Base.transaction do
      collection.each do |result|
        # バリデーションを全てかけたいからsave!ではなくsaveを使用
        is_success = false unless result.save
      end
      # バリデーションエラーがあった時は例外を発生させてロールバックさせる
      raise ActiveRecord::RecordInvalid unless is_success
    end
    rescue
      p 'エラー'
    ensure
      return is_success
  end


end