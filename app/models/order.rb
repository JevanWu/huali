class Order < ActiveRecord::Base

  attr_accessible :line_items, :address_attributes, :payments_attributes,
                  :line_items_attributes, :address, :number, :special_instructions

  has_one :address

  belongs_to :user

  has_many :line_items, :dependent => :destroy, :order => "created_at ASC"
  # has_many :payments, :dependent => :destroy
  # has_many :shipments, :dependent => :destroy

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :address
  # accepts_nested_attributes_for :payments
  # accepts_nested_attributes_for :shipments

  # before_filter :authenticate_user!

  # Queries
  def self.by_number(number)
    where(:number => number)
  end

  def self.between(start_date, end_date)
    where(:created_at => start_date..end_date)
  end

  def self.by_customer(customer)
    joins(:user).where("#{Spree.user_class.table_name}.email" => customer)
  end

  def self.by_state(state)
    where(:state => state)
  end

  def self.complete
    where('completed_at IS NOT NULL')
  end

  def self.incomplete
    where(:completed_at => nil)
  end

  def to_param
    number.to_s.to_url.upcase
  end

  def completed?
    !! completed_at
  end

  def checkout_allowed?
    line_items.count > 0
  end
end
