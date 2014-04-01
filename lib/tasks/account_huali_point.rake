namespace :huali_point do
  desc "reset the users' huali points and count the huali points from point transaction annually"
  task annual_reset_and_accounting: :reset_huali_point do
    User.transaction do
      users = User.all
      users.each do |user| 
        user.lock!
        user.huali_point = 0 
        valid_transactions = PointTransaction.where(user: user, 
                                                    created_at: -1.year.from_now.beginning_of_year .. -1.year.from_now.end_of_year)
        valid_transactions.each do |transaction| 
          if %w(income, refund).any?{|x| x == transaction.transaction_type}
            user.huali_point += transaction.point
          else
            user.huali_point -= transaction.point
          end
          user.save!
        end
      end
    end
  end
end
