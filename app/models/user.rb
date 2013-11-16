# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  email               :string(255)      default(""), not null
#  remember_created_at :datetime
#  sign_in_count       :integer          default(0)
#  current_sign_in_at  :datetime
#  last_sign_in_at     :datetime
#  current_sign_in_ip  :string(255)
#  last_sign_in_ip     :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  identity_url        :string(255)
#  is_student          :boolean
#  lastname            :string(255)
#  firstname           :string(255)
#

#this method will be deprecated as soon as open id returns the email
def email_from_identity_url(identity_url)
    username = identity_url.reverse[0..identity_url.reverse.index('/')-1].reverse
    return username + '@student.hpi.uni-potsdam.de'
end

class User < ActiveRecord::Base
    # Include default devise modules. Others available are:
    # :token_authenticatable, :confirmable,
    # :lockable, :timeoutable and :omniauthable
    devise :rememberable, :trackable, :openid_authenticatable

    validates :email, uniqueness: { case_sensitive: false }
    validates :identity_url, uniqueness: true

    def self.build_from_identity_url(identity_url)
        User.new(identity_url: identity_url, email: email_from_identity_url(identity_url))
    end
    
    def self.openid_required_fields
       ['email', 'http://axschema.org/contact/email']
    end

    def openid_fields=(fields)
        fields.each do |key, value|
            # Some AX providers can return multiple values per key
            if value.is_a? Array
                value = value.first
            end

            case key.to_s
                when 'first', 'http://axschema.org/namePerson/first'
                    self.firstname = value unless value.blank?
                when 'last', 'http://axschema.org/namePerson/last'
                    self.lastname = value unless value.blank?
                when 'email', 'http://axschema.org/contact/email'
                    self.email = value unless value.blank?
                else
                    logger.error "Unknown OpenID field: #{key}"
            end
        end
    end
end
