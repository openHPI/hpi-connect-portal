# == Schema Information
#
# Table name: job_offers
#
#  id          :integer          not null, primary key
#  description :text
#  title       :string(255)
#  chair       :string(255)
#  room_number :string(255)
#  start_date  :date
#  end_date    :date
#  programming_language_ids  : {}
#  language_ids  : {}
#  created_at  :datetime
#  updated_at  :datetime


require 'spec_helper'

describe JobOffer do

  describe 'applying' do

    before(:each) do
      @job_offer = FactoryGirl.create(:joboffer)
      @user = User.create
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
    assert JobOffer.create(title:"Awesome Job", description: "Develope a website", chair:"Epic", 
      start_date: Date.new(2013,11,1), compensation: 10.5, time_effort: 9).valid?
  end

  it "does not create a joboffer if start_date is after end_date" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", 
      chair:"Epic", start_date: Date.new(2013,11,1), end_date: Date.new(2013,10,1), compensation: 10.5, time_effort: 9).valid?
  end

  it "does create a joboffer if end_date is after start_date" do
    assert JobOffer.create(title:"Awesome Job", description: "Develope a website", chair:"Epic", 
      start_date: Date.new(2013,11,1), end_date: Date.new(2013,12,1), compensation: 10.5, time_effort: 9).valid?
  end

  it "does not create a joboffer if compensation is not a number" do
    assert !JobOffer.create(title:"Awesome Job", description: "Develope a website", chair:"Epic", 
      start_date: Date.new(2013,11,1), compensation: "i gonna be rich", time_effort: 9).valid?
  end

  it "returns job offers sorted by start_date" do
        
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,2,1), end_date: Date.new(2013,3,1), created_at: Date.new(2013, 2,1))
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,10,1), end_date: Date.new(2013,11,2), created_at: Date.new(2013,10,1))
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,1,1), end_date: Date.new(2013,5,1), created_at: Date.new(2013,1,1))
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,7,1), end_date: Date.new(2013,8,1), created_at: Date.new(2013,7,1))
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,4,1), end_date: Date.new(2013,5,1), created_at: Date.new(2013,4,1))

    sorted_job_offers = JobOffer.sort "date"
    (sorted_job_offers).each_with_index do |offer, index|

       if !sorted_job_offers.length == (index + 1)  
        offer.created_at.should <= sorted_job_offers[index+1].created_at
       end    
    end
  end

  it "returns job offers sorted by their chair" do
        
    FactoryGirl.create(:joboffer, chair: "Internet Technologies")
    FactoryGirl.create(:joboffer, chair: "EPIC")
    FactoryGirl.create(:joboffer, chair: "Software Architecture")
    FactoryGirl.create(:joboffer, chair: "Information Systems")
    FactoryGirl.create(:joboffer, chair: "Operating Systems & Middleware")

    sorted_job_offers = JobOffer.sort "chair"
    (sorted_job_offers).each_with_index do |offer, index|

       if sorted_job_offers.length == (index + 1) 
        break
       end
      offer.chair.should <= sorted_job_offers[index+1].chair
    end
  end

  it "returns job offers including the word EPIC" do
        
    FactoryGirl.create(:joboffer, chair: "EPIC")
    FactoryGirl.create(:joboffer, chair: "EPIC")
    FactoryGirl.create(:joboffer, chair: "Software Architecture", description: "develop a website with an epic framework")
    FactoryGirl.create(:joboffer, chair: "Information Systems")
    FactoryGirl.create(:joboffer, chair: "Operating Systems & Middleware")

    resulted_job_offers = JobOffer.search("epic")
    assert_equal(resulted_job_offers.length, 3);
  end

  it "returns job offers filtered by chair EPIC and start_date >= 20131125" do
        
    FactoryGirl.create(:joboffer, chair: "EPIC", start_date: Date.new(2013,11,26), end_date: Date.new(2013,12,26))
    FactoryGirl.create(:joboffer, chair: "EPIC", start_date: Date.new(2013,11,1), end_date: Date.new(2013,11,26))
    FactoryGirl.create(:joboffer, chair: "EPIC",start_date: Date.new(2013,12,1), end_date: Date.new(2013,12,26))
    FactoryGirl.create(:joboffer, chair: "Software Architecture")
    FactoryGirl.create(:joboffer, chair: "Information Systems")
    FactoryGirl.create(:joboffer, chair: "Operating Systems & Middleware")

    filtered_job_offers = JobOffer.filter({:chair => "EPIC", :start_date => "20131125"})
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered start_date >= 20131125" do
        
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,11,26), end_date: Date.new(2013,12,26))
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,11,1), end_date: Date.new(2013,11,26))
    FactoryGirl.create(:joboffer, start_date: Date.new(2013,12,1), end_date: Date.new(2013,12,26))
  

    filtered_job_offers = JobOffer.filter({:start_date => "20131125"})
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered by chair EPIC" do
        
    FactoryGirl.create(:joboffer, chair: "EPIC")
    FactoryGirl.create(:joboffer, chair: "EPIC")
    FactoryGirl.create(:joboffer, chair: "EPIC")
    FactoryGirl.create(:joboffer, chair: "Software Architecture")
    FactoryGirl.create(:joboffer, chair: "Information Systems")
    FactoryGirl.create(:joboffer, chair: "Operating Systems & Middleware")

    filtered_job_offers = JobOffer.filter({:chair => "EPIC"})
    assert_equal(filtered_job_offers.length, 3);
  end

  it "returns job offers filtered between 20131125 and 20131226" do
        
    FactoryGirl.create(:joboffer, chair: "EPIC", start_date: Date.new(2013,11,26), end_date: Date.new(2013,12,26))
    FactoryGirl.create(:joboffer, chair: "EPIC", start_date: Date.new(2013,11,1), end_date: Date.new(2013,11,26))
    FactoryGirl.create(:joboffer, chair: "EPIC",start_date: Date.new(2013,12,1), end_date: Date.new(2013,12,26))

    filtered_job_offers = JobOffer.filter({:start_date => "20131125", :end_date => "20131227"})
    assert_equal(filtered_job_offers.length, 2);
  end

  it "returns job offers filtered with compensation>=10 AND time_effort<=5" do
        
    FactoryGirl.create(:joboffer, time_effort: 10, compensation: 20)
    FactoryGirl.create(:joboffer, time_effort: 5, compensation: 20)
    FactoryGirl.create(:joboffer, time_effort: 8, compensation: 5)
    FactoryGirl.create(:joboffer, time_effort: 4, compensation: 8)

    filtered_job_offers = JobOffer.filter({:compensation => 10, :time_effort => 5})
    assert_equal(filtered_job_offers.length, 1);
  end



  it "returns job offers searched for programming languages filtered by time effort and sorted by chair" do

    FactoryGirl.create(:joboffer, time_effort: 10, chair: "Software Architecture", description: "Ruby Programming")
    FactoryGirl.create(:joboffer, time_effort: 8, chair: "Information Systems", description: "Ruby Programming")
    FactoryGirl.create(:joboffer, time_effort: 5, chair: "EPIC", description: "Javascript Programming")
    FactoryGirl.create(:joboffer, time_effort: 4, chair: "Operating Systems & Middleware", description: "Ruby Programming")

    filtered_job_offers = JobOffer.find_jobs({:sort => "chair", :search => "Ruby", :filter => {:time_effort => 8}})
    assert_equal(filtered_job_offers.length, 2);
    assert_equal(filtered_job_offers[0].chair, "Information Systems");
    assert_equal(filtered_job_offers[1].chair, "Operating Systems & Middleware");
  end



  it "returns job offers filtered by status" do
    job_offer_with_status = FactoryGirl.create(:joboffer, status:"completed");
    FactoryGirl.create(:joboffer);
    filtered_job_offers = JobOffer.filter({:status => "completed"})
    assert filtered_job_offers.include? job_offer_with_status
    assert_equal(filtered_job_offers.length, 1);
  end
end
