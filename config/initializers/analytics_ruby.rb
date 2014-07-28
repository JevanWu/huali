Analytics = Segment::Analytics.new({
    write_key: Rails.env == 'production' ? ENV['SEGMENTIO_KEY'] : ENV['SEGMENTIO_DEV_KEY'],
    on_error: Proc.new { |status, msg| Squash::Ruby.notify(ArgumentError.new(status), { message: msg, status: status }) }
})
