require 'spec_helper'

describe "home/imprint" do
  it "should render all the necessary information" do
    render

    rendered.should have_content I18n.t("home.imprint.headline")

    rendered.should have_content I18n.t("home.imprint.hpi.headline")
    rendered.should have_content I18n.t("home.imprint.hpi.street")
    rendered.should have_content I18n.t("home.imprint.hpi.city")
    rendered.should have_content I18n.t("home.imprint.hpi.tel")
    rendered.should have_content I18n.t("home.imprint.hpi.fax")
    rendered.should have_content I18n.t("home.imprint.hpi.email")
    rendered.should have_content I18n.t("home.imprint.hpi.internet_title")

    rendered.should have_content I18n.t("home.imprint.manager.person")
    rendered.should have_content I18n.t("home.imprint.manager.court")
    rendered.should have_content I18n.t("home.imprint.manager.court_num")

    rendered.should have_content I18n.t("home.imprint.content_resp.name")

    rendered.should have_content I18n.t("home.imprint.editor.name")

    rendered.should have_content I18n.t("home.imprint.design.name")

    rendered.should have_content I18n.t("home.imprint.text.name")

    rendered.should have_content I18n.t("home.imprint.info.text")
  end
end
