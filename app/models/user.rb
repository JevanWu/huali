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
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :anonymous_token, :phone, :name, :humanizer_answer, :humanizer_question_id

  has_many :addresses
  has_many :orders
  has_many :transactions, through: :orders
  has_many :shipments, through: :orders

  include Humanizer
  require_human_on :create

  scope :registered, where("#{self.table_name}.email NOT LIKE ?", "%@guest.me")
  scope :guests, where("#{self.table_name}.email LIKE ?", "%@guest.me")
  scope :non_guests, where("#{self.table_name}.email NOT LIKE ?", "%@guest.me")
  scope :all, -> { reorder }

  validates :role, inclusion: {
    in: %w(customer),
    message: "%{value} is not a valid user role."
  }

  class << self
    def build_guest
      u = User.create(email: "guest_#{Time.now.to_i}#{rand(99)}@guest.me")
      u.save(validate: false)
      u
    end
  end

  def subscribe_to_mailchimp
    gb = Gibbon.new ENV['MAILCHIMP_API_KEY'], timeout: 60
    gb.list_subscribe(
      id: ENV['MAILCHIMP_LIST_ID'],
      email_address: email,
      merge_vars: {FNAME: name, LNAME: ''},
      double_optin: false,
      update_existing: true,
      replace_interests: true
    )
  end

  def guest?
    !!(email =~ /@guest.me/)
  end

  def username
    email.sub(/(@.+)/,'').truncate(15)
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
        break token unless find(:first, conditions: { column => token })
      end
    end
end
