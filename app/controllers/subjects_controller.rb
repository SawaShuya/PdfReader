class SubjectsController < ApplicationController
  def index
    @subjects = Subject.all
  end

  def test_numbers
    @subject = Subject.find(params[:subject_id])
    @test_subjects = @subject.test_subjects.page(params[:page])
  end
end
