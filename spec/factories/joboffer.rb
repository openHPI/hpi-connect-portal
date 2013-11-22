FactoryGirl.define do

  factory :joboffer, class: JobOffer do
    title        "Awesome Job"
    description  "Develope a website"
    chair        "Epic"
    start_date   Date.new(2013,1,1)
    end_date     Date.new(2013,2,1)
    compensation 10.5
    time_effort  9
  end

end