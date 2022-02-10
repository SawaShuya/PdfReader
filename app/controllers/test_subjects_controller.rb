class TestSubjectsController < ApplicationController

  def show
    @test_subject = TestSubject.find(params[:id])
    @questions = @test_subject.questions
  end
end
