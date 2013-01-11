# == Schema Information
#
# Table name: administrators
#
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  id                     :integer          not null, primary key
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :string(255)
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_administrators_on_email                 (email) UNIQUE
#  index_administrators_on_reset_password_token  (reset_password_token) UNIQUE
#

FactoryGirl.define do
  factory :administrator do
    email { Forgery(:internet).email_address }
    password { Forgery(:basic).password }
    password_confirmation { password }
    # confirmed_at Time.now
  end
end
