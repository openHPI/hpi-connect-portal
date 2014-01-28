require 'spec_helper'

describe ApplicationController do

  it "returns a student_path for after_sign_in_path_for for a should_redirect_to_profile resource" do
    user = FactoryGirl.create(:user)
    user.should_redirect_to_profile = true

    expect(controller.after_sign_in_path_for(user)).to eq(student_path(user))
  end

  it "returns a job_offers_path for after_sign_in_path_for for a not should_redirect_to_profile resource" do
    user = FactoryGirl.create(:user)
    expect(controller.after_sign_in_path_for(user)).to eq(job_offers_path)
  end

end