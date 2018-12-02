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

require 'rails_helper'

describe CvJob do

  describe "validations" do
    let(:student) { FactoryBot.create(:student) }

    it "is not valid with empty attributes" do
      expect(CvJob.new).not_to be_valid
    end

    it "is not valid without student" do
      expect(CvJob.new(
        position:     'Ruby on Rails developer',
        employer:     'SAP AG',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      )).not_to be_valid
    end

    it "is not valid without position" do
      expect(CvJob.new(
        student:      student,
        employer:     'SAP AG',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      )).not_to be_valid
    end

    it "is not valid without employer" do
      expect(CvJob.new(
        student:      student,
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        end_date:     Date.current - 10,
        current:      false
      )).not_to be_valid
    end

    it "is not valid without start_date" do
      expect(CvJob.new(
        student:      student,
        employer:     'SAP AG',
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        end_date:     Date.current - 10,
        current:      false
      )).not_to be_valid
    end

    it "is not valid without end_date except if current is true" do
      expect(CvJob.new(
        student:      student,
        employer:     'SAP AG',
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        current:      false
      )).not_to be_valid
      expect(CvJob.new(
        student:      student,
        employer:     'SAP AG',
        position:     'Ruby on Rails developer',
        description:  'Developing a career portal',
        start_date:   Date.current - 100,
        current:      true
      )).to be_valid
    end
  end

  describe "querying" do
    before(:each) do
      @oldest = FactoryBot.create(:cv_job, start_date: Date.today - 100.days, end_date: Date.today - 30.days)
      @middle = FactoryBot.create(:cv_job, start_date: Date.today - 90.days, end_date: Date.today - 30.days)
      @newer = FactoryBot.create(:cv_job, start_date: Date.today - 90.days, end_date: Date.today - 15.days)
      @newest = FactoryBot.create(:cv_job, start_date: Date.today - 90.days, end_date: Date.today - 20.days, current: true)
    end

    it "should be sorted by to and from date" do
      expect(CvJob.all).to eq([@newest, @newer, @middle, @oldest])
    end
  end
end
