# == Schema Information
#
# Table name: orders
#
#  address_id           :integer
#  completed_at         :datetime
#  created_at           :datetime         not null
#  delivery_date        :date             not null
#  gift_card_text       :text
#  id                   :integer          not null, primary key
#  identifier           :string(255)
#  item_total           :decimal(8, 2)    default(0.0), not null
#  payment_state        :string(255)
#  payment_total        :decimal(8, 2)    default(0.0)
#  shipment_state       :string(255)
#  special_instructions :text
#  state                :string(255)
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#

class Order < ActiveRecord::Base

  attr_accessible :line_items, :address_attributes, :special_instructions,
                  :gift_card_text, :delivery_date

  belongs_to :address
  belongs_to :user

  has_many :line_items, :order => "created_at ASC"
  has_many :transactions, :order => "created_at ASC"
  # has_many :shipments, :dependent => :destroy

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :address
  # accepts_nested_attributes_for :shipments

  before_validation :generate_identifier, :cal_total, on: :create

  validates :identifier, presence: true

  # Queries
  class << self
    def by_number(number)
      where(:number => number)
    end

    def between(start_date, end_date)
      where(:created_at => start_date..end_date)
    end

    def by_customer(customer)
      joins(:user).where("#{Spree.user_class.table_name}.email" => customer)
    end

    def by_state(state)
      where(:state => state)
    end

    def complete
      where('completed_at IS NOT NULL')
    end

    def incomplete
      where(:completed_at => nil)
    end

    def full_info(key)
      includes(:user, :transactions).find_by_id(key)
    end
  end

  def generate_identifier
    self.identifier = uid_prefixed_by('OR')
  end

  def generate_transaction(options)
    default = {
      amount: self.total,
      subject: subject_text,
      body: body_text
    }
    self.transactions.create default.merge(options)
  end

  def add_line_item(product_id, quantity)
    this_item = LineItem.create(product_id: product_id, quantity: quantity)
    self.line_items << this_item
  end

  def cal_total
    self.total = line_items.inject(0) { |sum, item| sum + item.total }
  end

  def completed?
    !! completed_at
  end

  def checkout_allowed?
    line_items.count > 0
  end

  private

  def subject_text
    line_items.inject('') { |sum, item| sum + "#{item.name} * #{item.quantity} |"}
  end

  def body_text
    # prepare body text for transaction
  end
end
