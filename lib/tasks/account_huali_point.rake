namespace :huali_point do
  desc "reset the users' huali points and count the huali points from point transaction annually"
  task annual_reset_and_accounting: :environment do
    User.find_each do |user|
      user.transaction do
        user.lock!

        annual_huali_points = 0
        user.point_transactions.unexpired.each do |transaction|
          if %w(income refund).include?(transaction.transaction_type)
            annual_huali_points += transaction.point
          else
            annual_huali_points -= transaction.point
          end
        end

        user.update_column(:huali_point, 0.0)
        user.edit_huali_point(annual_huali_points) unless annual_huali_points == 0
      end
    end
  end


  desc "notify customers their huali points will be expired soon on each 30th November "
  task notify_customers_to_use_points: :environment do
    Sms.delay.huali_point_notify_sms
  end
end
