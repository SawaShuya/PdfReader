class TestNumbersController < ApplicationController
  def index
    @test_numbers = TestNumber.all
    @years = @test_numbers.map { |test_number| test_number.year }.uniq
  end

  def subjects
    @year = params[:year]
    test_number_ids = TestNumber.where(year: @year).map { |test_number| test_number.id }
    @test_subjects = TestSubject.where(test_number_id: test_number_ids)
  end

end
