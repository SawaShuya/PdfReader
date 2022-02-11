class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :new]

  def index
    @questions = Question.search(params[:search_word]).page(params[:page])
  end

  def new; end

  def create

  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    collect_answers = [params[:question][:collect_answer1], params[:question][:collect_answer2], params[:question][:collect_answer3], params[:question][:collect_answer4], params[:question][:collect_answer5]]

    if @question.update(question_params)
      @question.update_collect_numbers(collect_answers)
      flash[:notice] = "更新しました!"
    end
    redirect_to question_path(@question)
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
      flash[:notice] = "登録しました ! "
      redirect_to questions_path
    end
  end

  def create_collection
    @questions = QuestionCollection.new(question_collect_params)
    if @questions.save
      redirect_to questions_path
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

  def question_params
    params.require(:question).permit(:text, :choice1, :choice2, :choice3, :choice4, :choice5, :comment, :attention, :answer1, :answer2, :answer3, :answer4, :answer5)
  end

  def save_texts(text_arr, test_number)
    @unsaved_questions_arr = []
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

      if texts[5].nil? && texts[0].scan("。").length == 2
        texts.insert(1, texts[0].split("。").reject(&:empty?).last)
        text[0] = texts[0].split("。").first
      end

      question = Question.new(test_subject_id: test_subject.id, text: texts[0], choice1: texts[1], choice2: texts[2], choice3: texts[3], choice4: texts[4], choice5: texts[5])
      question.attention = attention if attention.present?

      unless question.save
        @unsaved_questions_arr << question
      end
    end
    return @unsaved_questions_arr
  end

  def exchange_hash(questions)
    questions.map{|question| question.attributes}
  end


end
