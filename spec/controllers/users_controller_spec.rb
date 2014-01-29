require 'spec_helper'

describe UsersController do
  let(:user) { FactoryGirl.create(:user) }
  let(:student_role) { FactoryGirl.create(:role, :student) }
  let(:admin_role) { FactoryGirl.create(:role, :admin) }

  let(:valid_attributes) { { "firstname" => "Mister", "lastname" => "Awesome", "email" => "test@example.com", :semester => "1", :education => "Master", :academic_program => "Volkswirtschaftslehre", "role" => student_role } }
  let(:false_attributes) { { "firstname" => 123 } }
  let(:valid_session) { {} }

  before(:each) do
    sign_in FactoryGirl.create(:user)
  end

end
