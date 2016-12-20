# == Schema Information
#
# Table name: cv_educations
#
#  id          :integer          not null, primary key
#  student_id  :integer
#  degree      :string(255)
#  field       :string(255)
#  institution :string(255)
#  start_date  :date
#  end_date    :date
#  current     :boolean          default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'rails_helper'

describe CvEducation do

  describe "validations" do
    before(:each) do
      @student = FactoryGirl.create(:student)
    end

    it "should not be valid with empty attributes" do
      assert !CvEducation.new.valid?
    end

    it "should not be valid without student" do
      assert !CvEducation.new(
        degree:       'Bachelor of Science',
        field:        'IT Systems Engineering',
        institution:  'Hasso Plattner Institute',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without degree" do
      assert !CvEducation.new(
        student:      @student,
        field:        'IT Systems Engineering',
        institution:  'Hasso Plattner Institute',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without field" do
      assert !CvEducation.new(
        student:      @student,
        degree:       'Bachelor of Science',
        institution:  'Hasso Plattner Institute',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without field" do
      assert !CvEducation.new(
        student:      @student,
        degree:       'Bachelor of Science',
        field:        'IT Systems Engineering',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without start_date" do
      assert !CvEducation.new(
        student:      @student,
        degree:       'Bachelor of Science',
        field:        'IT Systems Engineering',
        institution:  'Hasso Plattner Institute',
        end_date:     Date.current - 10,
        current:      false
      ).valid?
    end

    it "should not be valid without end_date except current is true" do
      assert !CvEducation.new(
        student:      @student,
        degree:       'Bachelor of Science',
        field:        'IT Systems Engineering',
        institution:  'Hasso Plattner Institute',
        start_date:   Date.current - 100,
        current:      false
      ).valid?
      assert CvEducation.new(
        student:      @student,
        degree:       'Bachelor of Science',
        field:        'IT Systems Engineering',
        institution:  'Hasso Plattner Institute',
        start_date:   Date.current - 100,
        current:      true
      ).valid?
    end
  end

  describe "querying" do
    before(:each) do
      @oldest = FactoryGirl.create(:cv_education, start_date: Date.today - 100.days, end_date: Date.today - 30.days)
      @middle = FactoryGirl.create(:cv_education, start_date: Date.today - 90.days, end_date: Date.today - 30.days)
      @newer = FactoryGirl.create(:cv_education, start_date: Date.today - 90.days, end_date: Date.today - 15.days)
      @newest = FactoryGirl.create(:cv_education, start_date: Date.today - 90.days, end_date: Date.today - 20.days, current: true)
    end

    it "should be sorted by to and from date" do
      expect(CvEducation.all).to eq([@newest, @newer, @middle, @oldest])
    end
  end
end
