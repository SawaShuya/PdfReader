class QuestionsController < ApplicationController
  def index
    @questions = Question.all.includes(:test_subject).sort{|a, b| b.created_at <=> a.created_at}
  end

  def create

  end

  def create_from_pdf
    contents = params[:contents]
    test_number = TestNumber.find_or_create_by(test_number_params)
    @unsaved_questions=[]
    contents.each do |content|
      if content.path =~ /pdf\Z/
        reader = Poppler::Document.new(content.path)
        text_arr = reader.pages.map{|a| a.get_text + "\n"}.join.split("\n問題")
        @unsaved_questions.concat save_texts(text_arr, test_number)
      end
    end

    if @unsaved_questions.present?
      @questions = QuestionCollection.new(exchange_hash(@unsaved_questions))
      render "ajust_form"
    else
      redirect_to root_path
    end
  end

  def create_collection
    @questions = QuestionCollection.new(question_collect_params)
    if @questions.save
      redirect_to root_path
    else
      render "ajust_form"
    end
  end

  private
  def test_number_params
    params.permit(:number, :year)
  end

  def question_collect_params
    params.require(:questions)
  end

  def save_texts(text_arr, test_number)
    @unsaved_questions = []
    subject = Subject.find_or_create_by(name: text_arr.first)
    test_subject = TestSubject.find_or_create_by(test_number_id: test_number.id, subject_id: subject.id)

    text_arr.shift

    text_arr.each do |text|
      texts = text.split(/\n[0-9]+/).reject(&:empty?)
      texts.map{|text| text.gsub!(/\n/, "")}

      if texts.last.include?("（注）")
        attention = texts.last.split("（注）").last
        texts[texts.size-1] = texts.last.split("（注）").first
      end

      question = Question.new(test_subject_id: test_subject.id, text: texts[0], choice1: texts[1], choice2: texts[2], choice3: texts[3], choice4: texts[4], choice5: texts[5])
      question.attention = attention if attention.present?

      unless question.save
        @unsaved_questions << question
      end
    end

  end

  def exchange_hash(questions)
    questions.map{|question| question.attributes}
  end


end
