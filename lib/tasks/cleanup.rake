namespace :cleanup do
  desc "Remove guest accounts more than a week old."
  task guests: :environment do
    User.guests.where("created_at < ?", 1.week.ago).destroy_all
  end

  desc "Auto fail unclosing transactions older than 24 hours"
  task transactions: :environment do
    Transaction.where("created_at < :time and state = :state", time: 1.day.ago, state: 'processing').each do |t|
      t.failure
    end
  end

  desc "Auto cancel orders older than 1 hours"
  task orders: :environment do
    Order.where("created_at < :time and state = :state", time: 1.hour.ago, state: 'generated').each do |o|
      o.cancel
    end
  end

  desc "reset 'sold_total' of Product monthly"
  task reset_sold_total: :environment do
    products = Product.all

    products.each do |product|
      product.transaction do
        product.lock!
        product.update_column(:sold_total, 0) unless product.monthly_solds.by_date(Date.current).first
      end
    end
  end
end
