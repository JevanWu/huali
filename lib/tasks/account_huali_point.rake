namespace :huali_point do
  desc "reset the users' huali points and count the huali points from point transaction annually"
  task annual_reset_and_accounting: :environment do
    User.transaction do
      users = User.all
      users.each do |user| 
        user.lock!
        user.update_column(:huali_point, 0) 
        valid_transactions = PointTransaction.where(user: user, 
                                                    expires_on: -1.year.from_now.beginning_of_year .. -1.year.from_now.end_of_year)
        annual_huali_points = 0
        valid_transactions.each do |transaction| 
          if %w(income refund).any?{|x| x == transaction.transaction_type}
            annual_huali_points += transaction.point
          else
            annual_huali_points -= transaction.point
          end
        end
        user.edit_huali_point(annual_huali_points)
      end
    end
  end
end
