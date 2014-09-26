# == Schema Information
#
# Table name: users
#
#  anonymous_token          :string(255)
#  authentication_token     :string(255)
#  confirmation_sent_at     :datetime
#  confirmation_token       :string(255)
#  confirmed_at             :datetime
#  created_at               :datetime         not null
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string(255)
#  email                    :string(255)
#  encrypted_password       :string(255)      default("")
#  huali_point              :decimal(8, 2)    default(0.0)
#  id                       :integer          not null, primary key
#  invitation_accepted_at   :datetime
#  invitation_created_at    :datetime
#  invitation_limit         :integer
#  invitation_rewarded      :boolean          default(FALSE)
#  invitation_sent_at       :datetime
#  invitation_token         :string(255)
#  invited_and_paid_counter :integer          default(0)
#  invited_by_id            :integer
#  invited_by_type          :string(255)
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string(255)
#  name                     :string(255)
#  phone                    :string(255)
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string(255)
#  role                     :string(255)      default("customer"), not null
#  sign_in_count            :integer          default(0)
#  updated_at               :datetime         not null
#
# Indexes
#
#  index_users_on_anonymous_token       (anonymous_token) UNIQUE
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do
  factory :user do
    email { Forgery(:internet).email_address }
    password { Forgery(:basic).password }
    password_confirmation { password }
    name { Forgery(:name).full_name }
    phone { "18758161801" }
    authentication_token { Devise.friendly_token }
    bypass_humanizer true
    # confirmed_at Time.now
  end
end
