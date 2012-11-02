class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :anonymous_token

  has_many :addresses

  scope :registered, where("#{self.table_name}.email NOT LIKE ?", "%@changan.sample")

  def self.anonymous!
    token = User.generate_token(:anonymous_token)
    User.create(:email => "#{token}@changan.sample", :password => token, :password_confirmation => token, :anonymous_token => token)
  end

  def anonymous?
    email.nil? || email =~ /@changan.sample$/
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
