require 'sidekiq'

namespace :sidekiq do
  task :clean_needless_retries do
    query = Sidekiq::RetrySet.new

    query.select do |job|
      job.item['error_class'] == "Twilio::REST::RequestError"
    end.map(&:delete)

    query.select do |job|
      job.item['error_class'] == "ActionView::Template::Error"
    end.map(&:delete)

    query.select do |job|
      job.item['error_class'] == "StandardError" && job.item['error_message'].include?("短信发送未成功")
    end.map(&:delete)

    query.select do |job|
      job.item['error_class'] == "NoMethodError" && job.item['error_message'].include?("nil:NilClass")
    end.map(&:delete)
  end
end
