require 'rails_helper'

describe "employers/index" do
  before(:each) do
    @employer_1 = FactoryBot.create(:employer)
    @employer_2 = FactoryBot.create(:employer)
    assign(:employers, [@employer_1, @employer_2])

    premium_employer_1 = FactoryBot.create(:employer, :premium)

    premium_employer_2 = FactoryBot.create(:employer, :premium)

    allow(premium_employer_1.avatar).to receive(:url){"/some/url/premium_empl_image"}
    allow(premium_employer_2.avatar).to receive(:url){"/another/url/premium_empl_image"}

    assign(:premium_employers,[premium_employer_1, premium_employer_2])

    allow(view).to receive(:can?) { false }
    allow(view).to receive(:signed_in?) { false }
  end

  it "renders a list of employers" do
    allow(view).to receive(:will_paginate)
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "h4", text: @employer_1.name, count: 1
    assert_select "h4", text: @employer_2.name, count: 1
  end

  it "only renders the new employer button for the admin" do
    allow(view).to receive(:will_paginate)
    allow(view).to receive(:can?) { true }
    render

    assert_select "a", text: I18n.t('employers.new_employer')
  end

  it "renders images of premium employers inside a carousel" do
    allow(view).to receive(:will_paginate)
    render

    assert_select ".carousel img", count: 2

    assert_select ".carousel img[src='/some/url/premium_empl_image']", count: 1
    assert_select ".carousel img[src='/another/url/premium_empl_image']", count: 1
  end

end
