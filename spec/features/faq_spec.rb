require 'spec_helper'

describe Faq do
  before(:each) do
    @faq = Faq.new("question" => "How do I make edits to my profile?", "answer" => "Log in to your account. Then hover over My Profile at the top right of the page. Choose the Edit-Button.",  "locale" => "en")
  end

  describe "validation of parameters" do

    it "with question not present" do
      @faq.question = nil
      expect(@faq).to be_invalid
    end

    it "with answer not present" do
      @faq.answer = nil
      expect(@faq).to be_invalid
    end

    it "with all necessary parameters present" do
      expect(@faq).to be_valid
    end
  end
end


describe "FAQ page" do

  let(:user) { FactoryGirl.create(:user) }

  before(:each) do
    @faq = Faq.create!([{
        question: "How do I make edits to my profile?",
        answer: 'Log in to your account. Then hover over "My profile" at the top right of the page. Choose the Edit-Button.',
        locale: "en"}])
  end

  it 'should return a page for FAQ' do
    @student = FactoryGirl.create(:student)
    login @student.user
    visit faqs_path
    expect(page).to have_content "FAQ"
  end


  it 'should have a buttons for creating new FAQs' do
    admin = FactoryGirl.create(:user, :admin)
    login admin

    visit faqs_path
    expect(page).to have_content "FAQ"
    expect(page).to have_content "How do I make edits to my profile?"
    #find('How do I make edits to my profile').click
    page.find_link("New FAQ").click
    fill_in 'faq_question', with: 'How to add a new issue to FAQ.'
    fill_in 'faq_answer', with: 'This is the new explanation.'
    find('input[type="submit"]').click
    expect(page).to have_content "How to add a new issue to FAQ."
  end


  it 'should have a buttons for editing FAQs' do
    admin = FactoryGirl.create(:user, :admin)
    login admin

    visit faqs_path
    expect(page).to have_content "FAQ"
    expect(page).to have_content "How do I make edits to my profile?"
    #find('How do I make edits to my profile').click
    page.find_link("Edit").click
    fill_in 'faq_question', with: 'How to add a new issue to FAQ.'
    fill_in 'faq_answer', with: 'This is the new explanation.'
    find('input[type="submit"]').click
    expect(page).to have_content "How to add a new issue to FAQ."
  end
end
