# == Schema Information
#
# Table name: job_offers
#
#  id                        :integer          not null, primary key
#  description               :text
#  title                     :string(255)
#  created_at                :datetime
#  updated_at                :datetime
#  start_date                :date
#  end_date                  :date
#  time_effort               :float
#  compensation              :float
#  employer_id               :integer
#  status_id                 :integer
#  flexible_start_date       :boolean          default(FALSE)
#  category_id               :integer          default(0), not null
#  state_id                  :integer          default(3), not null
#  graduation_id             :integer          default(2), not null
#  prolong_requested         :boolean          default(FALSE)
#  prolonged                 :boolean          default(FALSE)
#  prolonged_at              :datetime
#  release_date              :date
#  offer_as_pdf_file_name    :string(255)
#  offer_as_pdf_content_type :string(255)
#  offer_as_pdf_file_size    :integer
#  offer_as_pdf_updated_at   :datetime
#  student_group_id          :integer          default(0), not null
#

module JobOffersHelper
  def human_readable_start_date
    if @job_offer.flexible_start_date
      return t('job_offers.default_start_date')
    end
    @job_offer.start_date.to_s
  end

  def copy_employer_contact?(field)
    @job_offer.contact.method(field).nil? && signed_in_staff? && !current_user.manifestation.employer.nil? && !current_user.manifestation.employer.contact.nil?
  end
end
