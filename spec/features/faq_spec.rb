require 'spec_helper'

describe Faq do
  before(:each) do
    @faq = Faq.new("question" => "How do I make edits to my profile?", "answer" => "Log in to your account. Then hover over My Profile at the top right of the page. Choose the Edit-Button.")
  end 

  describe "validation of parameters" do
    
    it "with question not present" do
      @faq.question = nil
      @faq.should be_invalid
    end

    it "with answer not present" do
      @faq.answer = nil
      @faq.should be_invalid
    end

    it "with all necessary parameters present" do
      @faq.should be_valid
    end

  end
end


describe "FAQ page" do



  it 'should return a page for FAQ' do

    # @student = FactoryGirl.create(:user, role: FactoryGirl.create(:role, :student)) 
    # login_as(student, :scope => :user)
    visit faqs_path
    expect(page).to have_content "FAQ"
    end




    #  it 'should have a buttons for editing the FAQ page' do
    #     #login as wimi
    #     visit faqs_path
    #     expect(page).to have_content "FAQ"
    #     page.find_link('Edit').click
    #     fill_in 'faq_question', :with => 'How to add a new issue to FAQ.' 
    #     fill_in 'faq_answer', :with => 'This is the new explanation.'
    #     find('input[type="submit"]').click
    #     expect(page).to have_content "How to add a new issue to FAQ." 
    #      page.find_link('Back to FAQ').click

    # end

end