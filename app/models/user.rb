# == Schema Information
#
# Table name: users
#
#  anonymous_token          :string(255)
#  created_at               :datetime         not null
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string(255)
#  email                    :string(255)      default(""), not null
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
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_invitation_token      (invitation_token) UNIQUE
#  index_users_on_invited_by_id         (invited_by_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  include Phonelib::Extension
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :invitable, :async, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:douban, :weibo, :qq_connect]

  has_many :invitees, class_name: "User", foreign_key: "invited_by_id"
  belongs_to :inviter, class_name: "User", foreign_key: "invited_by_id"

  has_many :addresses
  has_many :orders
  has_many :oauth_providers, dependent: :destroy
  has_many :transactions, through: :orders
  has_many :shipments, through: :orders
  has_many :oauth_services, dependent: :destroy
  has_many :surveys, dependent: :nullify
  has_one  :tracking_cookie, dependent: :destroy
  has_many :point_transactions, dependent: :destroy
  has_many :coupon_codes, dependent: :destroy

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

  def after_database_authentication
    GaTrackWorker.delay.user_sign_in_track(id)
  end

  def edit_invited_and_paid_counter(num=1)
    update_column(:invited_and_paid_counter, invited_and_paid_counter + num)
  end

  def edit_huali_point(point)
    update_column(:huali_point, huali_point + point)
  end

  def create_income_point_transaction(point, description=nil, transaction_id=nil)
    self.point_transactions.create(point: point, transaction_type: "income",
                                   description: description, expires_on: Date.current.end_of_year.advance(years: 1), transaction_id: transaction_id)
  end

  def create_expense_point_transaction(point, description=nil, transaction_id=nil)
    self.point_transactions.create(point: point, transaction_type: "expense",
                                   description: description, expires_on: Date.current.end_of_year.advance(years: 1), transaction_id: transaction_id)
  end

  def self.find_by_openid(openid)
    oauth_provider = OauthProvider.find_by identifier: openid
    if oauth_provider.nil?
      oauth_provider = OauthProvider.create(identifier: openid, provider: "wechat")
      user = oauth_provider.build_user(role: "customer")
      user.save(validate: false)
    else
      user = oauth_provider.user
    end

    return user
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
