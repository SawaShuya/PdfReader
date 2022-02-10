class TestSubjectsController < ApplicationController

  def show
    @test_subject = TestSubject.find(params[:id])
    @questions = @test_subject.questions.page(params[:page])
  end
end
