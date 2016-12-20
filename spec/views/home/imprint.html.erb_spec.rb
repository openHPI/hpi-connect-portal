require 'spec_helper'

describe "home/imprint" do
  it "should render all the necessary information" do
    render

    expect(rendered).to have_content I18n.t("home.imprint.headline")

    expect(rendered).to have_content I18n.t("home.imprint.hpi.headline")
    expect(rendered).to have_content I18n.t("home.imprint.hpi.street")
    expect(rendered).to have_content I18n.t("home.imprint.hpi.city")
    expect(rendered).to have_content I18n.t("home.imprint.hpi.tel")
    expect(rendered).to have_content I18n.t("home.imprint.hpi.fax")
    expect(rendered).to have_content I18n.t("home.imprint.hpi.email")
    expect(rendered).to have_content I18n.t("home.imprint.hpi.internet_title")

    expect(rendered).to have_content I18n.t("home.imprint.manager.person")
    expect(rendered).to have_content I18n.t("home.imprint.manager.court")
    expect(rendered).to have_content I18n.t("home.imprint.manager.court_num")

    expect(rendered).to have_content I18n.t("home.imprint.content_resp.name")

    expect(rendered).to have_content I18n.t("home.imprint.editor.name")

    expect(rendered).to have_content I18n.t("home.imprint.design.name")

    expect(rendered).to have_content I18n.t("home.imprint.text.name")

    expect(rendered).to have_content I18n.t("home.imprint.info.text")
  end
end
