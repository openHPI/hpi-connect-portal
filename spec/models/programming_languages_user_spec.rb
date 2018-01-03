# == Schema Information
#
# Table name: programming_languages_users
#
#  id                      :integer          not null, primary key
#  student_id              :integer
#  programming_language_id :integer
#  skill                   :integer
#

require 'rails_helper'

describe ProgrammingLanguagesUser do
  describe "does_skill_exist" do
    let(:student) {FactoryBot.create(:student)}
    let(:programming_language) {FactoryBot.create(:programming_language)}

    it "returns true if skill exist" do
      FactoryBot.create(:programming_languages_user, student: student, programming_language: programming_language)
      assert ProgrammingLanguagesUser.does_skill_exist_for_programming_language_and_student(programming_language, student)
    end

    it "returns false if skill doesn't exist" do
      assert !ProgrammingLanguagesUser.does_skill_exist_for_programming_language_and_student(programming_language, student)
    end
  end
end
