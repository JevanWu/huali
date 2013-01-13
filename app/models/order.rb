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
#  payment_total        :decimal(8, 2)    default(0.0)
#  special_instructions :text
#  state                :string(255)      default("ready")
#  total                :decimal(8, 2)    default(0.0), not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
# Indexes
#
#  index_orders_on_identifier  (identifier) UNIQUE
#

class Order < ActiveRecord::Base

  attr_accessible :line_items, :special_instructions, :address_attributes,
                  :gift_card_text, :delivery_date, :identifier, :state

  belongs_to :address
  belongs_to :user

  has_many :line_items, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :shipments, dependent: :destroy
  has_many :products, through: :line_items

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :address

  before_validation :generate_identifier, on: :create
  before_validation :cal_total

  validates :identifier, presence: true
  validates_presence_of :delivery_date, :state, :total, :item_total

  state_machine :state, :initial => :generated do
    # TODO implement an auth_state dynamically for each state
    before_transition :to => :wait_refund, :do => :auth_refund
    before_transition :to => :completed, :do => :complete_order
    before_transition :to => :wait_check, :do => :pay_order

    # use adj. for state with future vision
    # use v. for event name
    state :generated do
      transition :to => :wait_check, :on => :pay
      transition :to => :void, :on => :cancel
    end

    state :wait_check do
      validates_presence_of :payment_total

      transition :to => :wait_ship, :on => :check
      transition :to => :wait_refund, :on => :cancel
    end

    state :wait_ship do
      transition :to => :wait_confirm, :on => :ship
      transition :to => :wait_refund, :on => :cancel
    end

    state :wait_confirm do
      transition :to => :completed, :on => :confirm
    end

    state :wait_refund do
      transition :to => :void, :on => :refund
    end
  end

  scope :all, -> { reorder }
  scope :current, -> { where('delivery_date = ?', Date.current) }
  scope :tomorrow, -> { where("delivery_date = ?", Date.tomorrow) }
  scope :within_this_week, -> { where("delivery_date >= ? AND delivery_date <= ? ", Date.current.beginning_of_week, Date.current.end_of_week) }
  scope :within_this_month, -> { where("delivery_date >= ? AND delivery_date <= ? ", Date.current.beginning_of_month, Date.current.end_of_month) }

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
      includes(:user, :address, :transactions, :shipments).find_by_id(key)
    end
  end

  def generate_identifier
    self.identifier = uid_prefixed_by('OR')
  end

  def generate_transaction(pay_info, options = {})
    default = {
      amount: self.total,
      subject: subject_text,
      body: body_text
    }
    self.transactions.create default.merge(options), pay_info
  end

  # options = {
    # tracking_num: String
    # ship_method_id: Integer
    # note: String
    # cost: Integer (optional)
  # }
  def generate_shipment(options)
    self.shipments.create options
  end

  def add_line_item(product_id, quantity)
    this_item = LineItem.create(product_id: product_id, quantity: quantity)
    self.line_items << this_item
  end

  def cal_total
    self.item_total = self.total = line_items.map(&:total).inject(:+)
  end

  def completed?
    !! completed_at
  end

  def checkout_allowed?
    line_items.count > 0
  end

  def cancel_allowed?
    state.in? ['generated', 'wait_check']
  end

  def transaction_state
    transaction.state
  end

  def shipment_state
    shipment.state
  end

  def transaction
    transactions.last
  end

  def shipment
    shipments.last
  end

  def subject_text
    line_items.inject('') { |sum, item| sum + "#{item.name} x #{item.quantity}, "}
  end

  private

  def body_text
    # prepare body text for transaction
  end

  def auth_refund
    # TODO auth the admin for the refund actions
    true
  end

  def complete_order
    self.completed_at = Time.now
    save
  end

  def pay_order
    self.payment_total += self.transactions.by_state('completed').map(&:amount).inject(:+)
    save
  end
end
