# == Schema Information
#
# Table name: cv_jobs
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  position    :string(255)
#  employer    :string(255)
#  start_date  :date
#  end_date    :date
#  current     :boolean          default(FALSE)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe CvJob do
  
  describe "validations" do
    before(:each) do
      @student = FactoryGirl.create(:student)
    end
    
    it "should not be valid with empty attributes" do
      assert !CvJob.new.valid?
    end

    it "should not be valid without student" do
      assert !CvJob.new(
        position:     'Ruby on Rails developer',
        employer:     'SAP AG',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without position" do
      assert !CvJob.new(
        student:      @student,
        employer:     'SAP AG',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without employer" do
      assert !CvJob.new(
        student:      @student,
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without start_date" do
      assert !CvJob.new(
        student:      @student,
        employer:     'SAP AG',
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without end_date except current is true" do
      assert !CvJob.new(
        student:      @student,
        employer:     'SAP AG',
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        current:      false
      ).valid?
      assert CvJob.new(
        student:      @student,
        employer:     'SAP AG',
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        current:      true
      ).valid?
    end
  end

  describe "querying" do
    before(:each) do
      @oldest = FactoryGirl.create(:cv_job, start_date: Date.today - 100.days, end_date: Date.today - 30.days)
      @middle = FactoryGirl.create(:cv_job, start_date: Date.today - 90.days, end_date: Date.today - 30.days)
      @newest = FactoryGirl.create(:cv_job, start_date: Date.today - 90.days, end_date: Date.today - 15.days)
    end

    it "should be sorted by to and from date" do
      CvJob.all.should eq([@newest, @middle, @oldest])
    end
  end
end
