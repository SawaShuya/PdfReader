class QuestionsController < ApplicationController
  def index
    @questions = Question.all.includes(:test_subject).sort{|a, b| b.created_at <=> a.created_at}
  end

  def create

  end

  def create_from_pdf
    contents = params[:contents]
    test_number = TestNumber.find_or_create_by(test_number_params)
    contents.each do |content|
      question = Question.new
      if content.path =~ /pdf\Z/
        reader = Poppler::Document.new(content.path)
        text_arr = reader.pages.map{|a| a.get_text + "\n"}.join.split("\n問題")
        byebug
        save_texts(text_arr, test_number)
      end
    end
    redirect_to root_path
  end

  private
  def test_number_params
    params.permit(:number, :year)
  end

  def save_texts(text_arr, test_number)
    subject = Subject.find_or_create_by(name: text_arr.first)
    test_subject = TestSubject.find_or_create_by(test_number_id: test_number.id, subject_id: subject.id)

    text_arr.shift

    text_arr.each do |text|
      texts = text.split(/\n[0-9]+/).reject(&:empty?)
      texts.map{|text| text.gsub!(/\n/, "")}
      if texts.size == 6
        texts.concat [""]
      end

      Question.create!(test_subject_id: test_subject.id, text: texts[0], choice1: texts[1], choice2: texts[2], choice3: texts[3], choice4: texts[4], choice5: texts[5], attention: texts[6])
    end
  end


end
