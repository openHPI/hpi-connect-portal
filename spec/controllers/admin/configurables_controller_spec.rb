require 'spec_helper'

describe Admin::ConfigurablesController do
  let(:admin) { FactoryGirl.create(:user, :admin) }
  before(:all) do
    FactoryGirl.create(:job_status, :pending)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :completed)
  end
	describe "the data validation" do 
		before(:each) do
			login_as(admin, :scope => :user)
    	visit admin_configurable_path
    	#page.find('body').should_not be_nil
    	    	puts page.response_headers.inspect

		end
    
    it "checks if a valid email address is saved" do
    	find '#mailToAdministration' 
    	fill_in 'mailToAdministration', :with => 'user@example.com'
	    
	    click_button 'Save'

	    expect(page).to has_field?('mailToAdministration', :with => 'user@example.com')
    end
    it "checks if an invalid email address is not saved" do
      fill_in 'mailToAdministration', :with => 'user@'
	    
	    click_button 'Save'

	    expect(page).to has_field?('mailToAdministration', :with => Configurable[:mailToAdministration])
	    expect(page).to have_content(t("errors.configuration.invalid_email"))
    end
  end

end
