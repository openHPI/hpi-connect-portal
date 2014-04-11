require 'spec_helper'

describe "home/imprint" do
  it "should render all the necessary information" do
    render

    rendered.should have_content I18n.t("imprint.headline")

    rendered.should have_content I18n.t("imprint.hpi.headline")
    rendered.should have_content I18n.t("imprint.hpi.street")
    rendered.should have_content I18n.t("imprint.hpi.city")
    rendered.should have_content I18n.t("imprint.hpi.tel")
    rendered.should have_content I18n.t("imprint.hpi.fax")
    rendered.should have_content I18n.t("imprint.hpi.email")
    rendered.should have_content I18n.t("imprint.hpi.internet_title")

    rendered.should have_content I18n.t("imprint.manager.person")
    rendered.should have_content I18n.t("imprint.manager.court")
    rendered.should have_content I18n.t("imprint.manager.court_num")

    rendered.should have_content I18n.t("imprint.content_resp.name")

    rendered.should have_content I18n.t("imprint.editor.name")

    rendered.should have_content I18n.t("imprint.design.name")

    rendered.should have_content I18n.t("imprint.text.name")

    rendered.should have_content I18n.t("imprint.info.text")
  end
end
