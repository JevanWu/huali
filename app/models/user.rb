# == Schema Information
#
# Table name: users
#
#  anonymous_token        :string(255)
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
#  sign_in_count          :integer          default(0)
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_anonymous_token       (anonymous_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :anonymous_token

  has_many :addresses

  has_many :orders

  scope :registered, where("#{self.table_name}.email NOT LIKE ?", "%@guest.me")
  scope :guests, where("#{self.table_name}.email LIKE ?", "%@guest.me")

  class << self
    def build_guest
      u = User.create(email: "guest_#{Time.now.to_i}#{rand(99)}@guest.me")
      u.save(:validate => false)
      u
    end
  end

  def guest?
    !!(email =~ /@guest.me/)
  end

  private

    # Generate a friendly string randomically to be used as token.
    def self.random_token
      SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
    end

    # Generate a token by looping and ensuring does not already exist.
    def self.generate_token(column)
      loop do
        token = random_token
        break token unless find(:first, :conditions => { column => token })
      end
    end
end
