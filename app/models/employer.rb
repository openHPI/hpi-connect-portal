# == Schema Information
#
# Table name: employers
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  description_de        :text
#  created_at            :datetime
#  updated_at            :datetime
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  avatar_updated_at     :datetime
#  activated             :boolean          default(FALSE), not null
#  place_of_business     :string(255)
#  website               :string(255)
#  line_of_business      :string(255)
#  year_of_foundation    :integer
#  number_of_employees   :string(255)
#  requested_package_id  :integer          default(0), not null
#  booked_package_id     :integer          default(0), not null
#  single_jobs_requested :integer          default(0), not null
#  token                 :string(255)
#  description_en        :text
#

class Employer < ActiveRecord::Base
  NUMBER_OF_EMPLOYEES_FIELDS = ["< 50", "50 - 100", "100 - 500", "500 - 1000", "> 1000"]
  PACKAGES = ['free', 'profile', 'partner', 'premium']

  has_attached_file :avatar, style: { medium: "200x200" }, default_url: "/assets/placeholder/:style/missing.png"

  has_one :contact, as: :counterpart, dependent: :destroy

  has_many :ratings, dependent: :destroy

  has_many :staff_members, class_name: 'Staff', dependent: :destroy
  has_many :job_offers, dependent: :destroy
  has_many :interested_students, class_name: 'Student', through: :employers_newsletter_information

  before_validation :generate_unique_token

  accepts_nested_attributes_for :staff_members
  accepts_nested_attributes_for :contact

  validates_attachment_size :avatar, less_than: 5.megabytes
  validates_attachment_content_type :avatar, content_type: ['image/jpeg', 'image/png']

  validates :name, presence: true, uniqueness: true
  validates :year_of_foundation, numericality: { only_integer: true,
    greater_than: 1800,
    less_than_or_equal_to: Time.now.year}, allow_nil: true

  scope :active, -> { where(activated: true) }
  scope :paying, -> { where('booked_package_id >= ?', 1) }
  scope :order_by_name, -> { order('LOWER(name)') }

  translates :description, fallback: :any

  def generate_unique_token
    code = SecureRandom.urlsafe_base64
    code = SecureRandom.urlsafe_base64 while Employer.exists? token: code
    self.token = code
  end

  def check_deputys_employer
    errors.add(:deputy_id, 'must be a staff member of his employer.') unless deputy && deputy.employer == self
  end

  def requested_package
    PACKAGES[requested_package_id]
  end

  def package
    PACKAGES[booked_package_id]
  end

  def paying?
    booked_package_id >= 1
  end

  def partner?
    booked_package_id >= 2
  end

  def premium?
    booked_package_id == 3
  end

  def graduate_job_count
    job_offers.graduate_jobs.length
  end

  def graduate_job_count_this_year
    job_offers.graduate_jobs.where('extract(year from created_at) = ?', Date.today.year).length
  end

  def can_create_job_offer?(category)
    (category != 'graduate_job' || (partner? && graduate_job_count_this_year < (premium? ? 20 : 4))) ? true : false
  end

  def add_one_single_booked_job
    self.update_column :single_jobs_requested, self.single_jobs_requested+1
  end

  def remove_one_single_booked_job
    self.update_column :single_jobs_requested, self.single_jobs_requested-1
  end

  def average_rating
    if rating_amount > 0
      (Rating.where(employer: self).map{|x| x.score_overall}.reduce(:+) / rating_amount.to_f).round(1)
    end
  end

  def rating_amount
    Rating.where(employer: self).count
  end

  def invite_colleague(colleague_mail, name, sender)
    EmployersMailer.invite_colleague_email(self, colleague_mail, name, sender).deliver
  end

  def self.export_all
    CSV.generate(headers: true) do |csv|
      employer_attributes = %w{name}
      staff_member_attributes = %w{full_name email}
      headers = employer_attributes.map{ |attr| "employer_".concat(attr) } + staff_member_attributes.map{ |attr| "staff_member_".concat(attr) }
      csv << headers
      csv = self.add_employers_to_csv(csv, employer_attributes, staff_member_attributes)
    end
  end

  def self.add_employers_to_csv(csv, employer_attributes, staff_member_attributes)
    Employer.find_each do |employer|
      row = employer_attributes.map{ |attr| employer.send(attr)}

      staff_member = employer.staff_members.first
      row += staff_member_attributes.map{ |attr| staff_member.send(attr)}

      csv << row
    end
    return csv
  end

end
