class LimitedPromotion < ActiveRecord::Base
  belongs_to :product

  validates :name, :start_at, :end_at, :adjustment, :product, :available_count, presence: true

  # +/-/*/%1234.0
  validates_format_of :adjustment, with: %r{\A[+-x*%/][\s\d.]+\z}

  validates :available_count,
    numericality: { only_integer: true, greater_than_or_equal_to: 1, allow_blank: true },
    on: :create

  scope :start_today, -> { where(start_at: (Time.current.beginning_of_day)..(Time.current.end_of_day)) }

  def usable?
    started? && !expired? && !out_of_use_count?
  end

  def out_of_use_count?
    available_count <= 0
  end

  def expired?
    expired || end_at < Time.current
  end

  def use!
    decrement(:available_count)
    increment(:used_count)

    save
  end

  def close_to_start_time?
    start_in_seconds = start_at - Time.current

    start_in_seconds <= 30 * 60
  end

  def started?
    start_at <= Time.current
  end

  def ended?
    expired? || out_of_use_count?
  end

  def self.retrieve_by_products(product_ids)
    self.lock.start_today.where("product_id in (?)", product_ids)
  end
end
