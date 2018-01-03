# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description           :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#  token                 :string(255)
#

require 'rails_helper'

describe Employer do
  let(:employer) do
    FactoryBot.create(:employer)
  end

  describe "validation of parameters" do

    it "with name not present" do
      employer.name = nil
      expect(employer).to be_invalid
    end

    it "with name is not unique" do
      employer_with_same_name = employer.dup
      assert expect(employer_with_same_name).to be_invalid
    end

    it "with year_of_foundation less than 1800" do
      employer.year_of_foundation = 1745
      expect(employer).to be_invalid
    end

    it "with year_of_foundation greater than 1800" do
      employer.year_of_foundation = 1801
      expect(employer).to be_valid
    end

    it "with future year_of_foundation" do
      employer.year_of_foundation = Time.now.year + 1
      expect(employer).to be_invalid
    end

    it "creates token" do
      expect(employer.token).not_to be_nil
    end
  end

  describe "invite colleague" do

    before :each do
      ActionMailer::Base.deliveries =[]
      receiver_name = "Test Name"
      sender = FactoryBot.create(:user)
      employer.invite_colleague("test@mail.com", receiver_name, sender)
    end

    it "sends mail" do
      ActionMailer::Base.deliveries == 1
    end

  end

  describe "#average_rating" do
    context "employer rated" do
      it "returns the arithmetic mean of all rating scores" do
        r1 = FactoryBot.create(:rating, score_overall: 3, employer: employer)
        r2 = FactoryBot.create(:rating, score_overall: 4, employer: employer)

        expect(employer.average_rating).to be_within(0.05).of(((3+4)/2.0))
      end
    end

    context "employer not yet rated" do
      it "returns nil" do
        expect(employer.average_rating).to be_nil
      end
    end
  end

  describe "order by name" do
    it "orders by name case insensitive" do
      Employer.delete_all
      FactoryBot.create(:employer, name: "Ca")
      FactoryBot.create(:employer, name: "avis")
      FactoryBot.create(:employer, name: "eBay")
      FactoryBot.create(:employer, name: "Zuckerberg")
      FactoryBot.create(:employer, name: "AtTheTop")
      ordered_employers = Employer.order_by_name
      expect(ordered_employers[0].name).to eq("AtTheTop")
      expect(ordered_employers[1].name).to eq("avis")
      expect(ordered_employers[2].name).to eq("Ca")
      expect(ordered_employers[3].name).to eq("eBay")
      expect(ordered_employers[4].name).to eq("Zuckerberg")
    end
  end

  shared_examples "an employer with limited graduate job offers per year" do |limit|
    it "can create limited graduate job offers per year" do
      FactoryBot.create(:job_offer, category_id: 2, employer: employer, created_at: Date.today - 1.years)

      (limit-1).times do |n|
        FactoryBot.create(:job_offer, category_id: 2, employer: employer)
      end

      expect(employer.can_create_job_offer?('graduate_job')).to eq(true)

      FactoryBot.create(:job_offer, category_id: 2, employer: employer)

      expect(employer.can_create_job_offer?('graduate_job')).to eq(false)
    end
  end

  context "having booked the partner package" do
    let(:employer) do
      FactoryBot.create(:employer, booked_package_id: 2)
    end

    it_behaves_like "an employer with limited graduate job offers per year", 4
  end

  context "having booked the premium package" do
    let(:employer) do
      FactoryBot.create(:employer, booked_package_id: 3)
    end

    it_behaves_like "an employer with limited graduate job offers per year", 20
  end

  describe "export" do
    before(:each) do
      require 'csv'

      @registered_today = FactoryBot.create :employer
      @registered_a_year_ago = FactoryBot.create(:employer, created_at: Date.today - 1.years)

      @headers = %w{employer_name staff_member_full_name staff_member_email contact_street contact_zip_city}
    end

    it "should export all employers if options are set accordingly" do
      csv = CSV.parse(Employer.export(nil, nil))
      expect(csv[0]).to eq(@headers)
      expect(csv[1]).to eq([@registered_today.name, @registered_today.staff_members.first.full_name, @registered_today.staff_members.first.email, @registered_today.contact.street, @registered_today.contact.zip_city])
      expect(csv[2]).to eq([@registered_a_year_ago.name, @registered_a_year_ago.staff_members.first.full_name, @registered_a_year_ago.staff_members.first.email, @registered_a_year_ago.contact.street, @registered_a_year_ago.contact.zip_city])
    end

    it "should not include employers registered outside of timeframe specified" do
      csv = CSV.parse(Employer.export(Date.today - 6.months, Date.today))
      expect(csv[0]).to eq(@headers)
      expect(csv[1]).to eq([@registered_today.name, @registered_today.staff_members.first.full_name, @registered_today.staff_members.first.email, @registered_today.contact.street, @registered_today.contact.zip_city])
    end
  end

end
