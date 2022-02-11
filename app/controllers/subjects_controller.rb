class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def test_numbers
    @subject = Subject.find(params[:subject_id])
    @test_subjects = @subject.test_subjects.page(params[:page])
  end

  def questions
    @subject = Subject.find(params[:subject_id])
    test_subject_ids = TestSubject.where(subject_id: @subject.id).pluck(:id)
    @questions = Question.where(test_subject_id: test_subject_ids).page(params[:page])
  end
end
