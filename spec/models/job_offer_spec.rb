# == Schema Information
#
# Table name: job_offers
#
#  id                  :integer          not null, primary key
#  description         :text
#  title               :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  start_date          :date
#  end_date            :date
#  time_effort         :float
#  compensation        :float
#  room_number         :string(255)
#  chair_id            :integer
#  responsible_user_id :integer
#  status_id           :integer          default(1)
#  assigned_student_id :integer
#

require 'spec_helper'

describe JobOffer do

  before(:each) do
      @epic = FactoryGirl.create(:chair, name:"EPIC")
      @os = FactoryGirl.create(:chair, name:"OS and Middleware")
      @itas = FactoryGirl.create(:chair, name:"Internet and Systems Technologies")
      @responsible_user = FactoryGirl.create(:user)
  end

  describe 'applying' do

    before(:each) do
      @job_offer = FactoryGirl.create(:job_offer)
      @user = FactoryGirl.create(:user)
      @application = Application.create(user: @user, job_offer: @job_offer)
    end

    subject { @job_offer }

    its(:applications) { should include(@application) }
    its(:users) { should include(@user) }
  end

  it "does not create a joboffer if attributes are not set" do
    assert !JobOffer.create.valid?
  end

  it "does create a joboffer if all required attributes are set and valid" do
    assert JobOffer.create(title:"Awesome Job", description: "Develope a website", chair: @epic, 
      start_date: Date.current + 1, compensation: 10.5, time_effort: 9, responsible_user: @responsible_user).valid?
  end

  it "does not create a joboffer if the start_date is in the past" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", 
      chair: @epic, start_date: Date.current - 1, compensation: 10.5, time_effort: 9).valid?
  end

  it "does not create a joboffer if start_date is after end_date" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", 
      chair: @epic, start_date: Date.current + 2, end_date: Date.current + 1, compensation: 10.5, time_effort: 9).valid?
  end

  it "does create a joboffer if end_date is after start_date" do
    assert JobOffer.create(title:"Awesome Job", description: "Develope a website", chair: @epic, 
      start_date: Date.current + 1, end_date: Date.current + 2, compensation: 10.5, time_effort: 9, responsible_user: @responsible_user).valid?
  end

  it "does not create a joboffer if compensation is not a number" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", chair: @epic, 
      start_date: Date.current + 1, compensation: "i gonna be rich", time_effort: 9).valid?
  end

  it "does not create a joboffer without a responsible user" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", chair: @epic, 
      start_date: Date.current + 1, compensation: 10.5, time_effort: 9).valid?
  end

  it "returns job offers sorted by created_at" do
        
    FactoryGirl.create(:job_offer, start_date: Date.current + 2, end_date: Date.current + 3, created_at: Date.current + 2, chair: @epic)
    FactoryGirl.create(:job_offer, start_date: Date.current + 10, end_date: Date.current + 11, created_at: Date.current + 10, chair: @epic)
    FactoryGirl.create(:job_offer, start_date: Date.current + 1, end_date: Date.current + 2, created_at: Date.current + 1, chair: @epic)
    FactoryGirl.create(:job_offer, start_date: Date.current + 7, end_date: Date.current + 8, created_at: Date.current + 7, chair: @epic)
    FactoryGirl.create(:job_offer, start_date: Date.current + 4, end_date: Date.current + 5, created_at: Date.current + 4, chair: @epic)

    sorted_job_offers = JobOffer.sort "date"
    (sorted_job_offers).each_with_index do |offer, index|

       if !sorted_job_offers.length == (index + 1)  
        offer.created_at.should <= sorted_job_offers[index+1].created_at
       end    
    end
  end

  it "returns job offers sorted by their chair" do
        
    FactoryGirl.create(:job_offer, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @itas)
    FactoryGirl.create(:job_offer, chair: @os)

    sorted_job_offers = JobOffer.sort "chair"
    (sorted_job_offers).each_with_index do |offer, index|

       if sorted_job_offers.length == (index + 1) 
        break
       end
      offer.chair.name.should <= sorted_job_offers[index+1].chair.name
    end
  end

  it "returns job offers including the word EPIC" do
        
    FactoryGirl.create(:job_offer, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @itas, description: "develop a website with an epic framework")
    FactoryGirl.create(:job_offer, chair: @itas)
    FactoryGirl.create(:job_offer, chair: @os)

    resulted_job_offers = JobOffer.search("EPIC")
    assert_equal(resulted_job_offers.length, 3);
  end

  it "returns job offers filtered by chair EPIC and start_date >= specified_date" do
        
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 6, end_date: Date.current + 8)
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 1, end_date: Date.current + 8)
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 5, end_date: Date.current + 8)
    FactoryGirl.create(:job_offer, chair: @itas)
    FactoryGirl.create(:job_offer, chair: @os)

    filtered_job_offers = JobOffer.filter_chair(@epic.id).filter_start_date((Date.current + 3).strftime("%Y%m%d"))
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered start_date >= specified_date" do
        
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 6, end_date: Date.current + 8)
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 1, end_date: Date.current + 8)
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 5, end_date: Date.current + 8)

    filtered_job_offers = JobOffer.filter_start_date((Date.current + 3).strftime("%Y%m%d"))
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered by chair EPIC" do
        
    FactoryGirl.create(:job_offer, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @itas)
    FactoryGirl.create(:job_offer, chair: @os)

    filtered_job_offers = JobOffer.filter_chair(@epic.id)
    assert_equal(filtered_job_offers.length, 3);
  end

  it "returns job offers filtered between start_date and end_date" do
        
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 6, end_date: Date.current + 8, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 1, end_date: Date.current + 8, chair: @epic)
    FactoryGirl.create(:job_offer, chair: @epic, start_date: Date.current + 5, end_date: Date.current + 8, chair: @epic)

    filtered_job_offers = JobOffer.filter_start_date((Date.current + 3).strftime("%Y%m%d")).filter_end_date((Date.current + 9).strftime("%Y%m%d"))
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered with compensation>=10 AND time_effort<=5" do
        
    FactoryGirl.create(:job_offer, time_effort: 10, compensation: 20, chair: @epic)
    FactoryGirl.create(:job_offer, time_effort: 5, compensation: 20, chair: @epic)
    FactoryGirl.create(:job_offer, time_effort: 8, compensation: 5, chair: @epic)
    FactoryGirl.create(:job_offer, time_effort: 4, compensation: 8, chair: @epic)

    filtered_job_offers = JobOffer.filter_compensation(10).filter_time_effort(5)
    assert_equal(filtered_job_offers.length, 1);
  end

  it "returns job offers searched for programming languages filtered by time effort and sorted by chair" do

    FactoryGirl.create(:job_offer, time_effort: 10, chair: @epic, description: "Ruby Programming")
    FactoryGirl.create(:job_offer, time_effort: 8, chair: @itas, description: "Ruby Programming")
    FactoryGirl.create(:job_offer, time_effort: 5, chair: @epic, description: "Javascript Programming")
    FactoryGirl.create(:job_offer, time_effort: 4, chair: @os, description: "Ruby Programming")

    filtered_job_offers = JobOffer.sort("chair").search("Ruby").filter_time_effort(8)
    assert_equal(filtered_job_offers.length, 2);
    assert_equal(filtered_job_offers[0].chair, @itas);
    assert_equal(filtered_job_offers[1].chair, @os);
  end

  it "return job offers which only have the specified programming languages" do
    offer_matched = FactoryGirl.create(:job_offer, time_effort: 10, chair: @epic, description: "Ruby Programming")
    offer_not_matched = FactoryGirl.create(:job_offer, time_effort: 10, chair: @epic, description: "Python Programming")

    language_one = FactoryGirl.create(:programming_language, job_offer: [offer_matched])
    language_two = FactoryGirl.create(:programming_language, job_offer: [offer_matched])
    language_three = FactoryGirl.create(:programming_language, job_offer: [offer_not_matched])

    filtered_jobs = JobOffer.filter_programming_languages([language_one.id, language_two.id])
    assert_equal(filtered_jobs.length, 1)

    filtered_jobs = JobOffer.filter_programming_languages([language_one.id, language_two.id, language_three.id])
    assert_equal(filtered_jobs.length, 2)

    filtered_jobs = JobOffer.filter_programming_languages([])
    assert_equal(filtered_jobs.length, 0)
  end

  it "return job offers which only have the specified programming languages" do
    offer_matched = FactoryGirl.create(:job_offer, time_effort: 10, chair: @epic, description: "Ruby Programming")
    offer_not_matched = FactoryGirl.create(:job_offer, time_effort: 10, chair: @epic, description: "Python Programming")

    language_one = FactoryGirl.create(:language)
    language_two = FactoryGirl.create(:language)
    language_three = FactoryGirl.create(:language)

    offer_matched.languages = [language_one, language_two]
    offer_matched.save

    offer_not_matched.languages = [language_three]
    offer_not_matched.save

    filtered_jobs = JobOffer.filter_languages([language_one.id, language_two.id])
    assert_equal(filtered_jobs.length, 1)

    filtered_jobs = JobOffer.filter_languages([language_one.id, language_two.id, language_three.id])
    assert_equal(filtered_jobs.length, 2)

    filtered_jobs = JobOffer.filter_languages([])
    assert_equal(filtered_jobs.length, 0)
  end

 
  it "returns job offers filtered by status" do
    @status = FactoryGirl.create(:job_status, :name => "completed")
    job_offer_with_status = FactoryGirl.create(:job_offer, status: @status);
    FactoryGirl.create(:job_offer, chair: @epic);
    filtered_job_offers = JobOffer.where(:status => @status)
    assert filtered_job_offers.include? job_offer_with_status
    assert_equal(filtered_job_offers.length, 1);
  end
end
