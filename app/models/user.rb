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
#  name                   :string(255)
#  phone                  :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  role                   :string(255)      default("customer"), not null
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
  include Phonelib::Extension
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:douban, :weibo, :qq_connect]

  has_many :addresses
  has_many :orders
  has_many :transactions, through: :orders
  has_many :shipments, through: :orders
  has_many :oauth_services, dependent: :destroy
  has_many :surveys, dependent: :nullify
  has_one  :tracking_cookie, dependent: :destroy

  delegate :ga_client_id, to: :tracking_cookie, allow_nil: true

  include Humanizer
  attr_accessor :bypass_humanizer
  require_human_on :create, :unless => :bypass_humanizer

  scope :registered, -> { where("#{self.table_name}.email NOT LIKE ?", "%@guest.me") }
  scope :guests, -> { where("#{self.table_name}.email LIKE ?", "%@guest.me") }
  scope :non_guests, -> { where("#{self.table_name}.email NOT LIKE ?", "%@guest.me") }

  validates :role, inclusion: {
    in: %w(customer),
    message: "%{value} is not a valid user role."
  }

  phoneize :phone
  validates :phone, phone: { allow_blank: true }

  class << self
    def build_guest
      u = User.create(email: "guest_#{Time.now.to_i}#{rand(99)}@guest.me")
      u.save(validate: false)
      u
    end
  end

  def guest?
    !!(email =~ /@guest.me/)
  end

  def username
    email.sub(/(@.+)/,'').truncate(15)
  end

  def apply_oauth(oauth_info)
    oauth_services.build(
      provider: oauth_info['provider'],
      uid: oauth_info['uid']
    )
    self.save!
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
        break token unless where(column => token).exists?
      end
    end
end
