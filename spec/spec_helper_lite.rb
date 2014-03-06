require 'rspec'
require 'rr'
$:.unshift File.expand_path '.', __FILE__
$:.unshift File.expand_path '../../app/models', __FILE__
$:.unshift File.expand_path '../../app/services', __FILE__
$:.unshift File.expand_path '../../app/decorators', __FILE__
$:.unshift File.expand_path '../../app/models/validators', __FILE__
$:.unshift File.expand_path '../../lib', __FILE__

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.fail_fast = false

  # only use the should configuration
  config.expect_with :rspec do |c|
    c.syntax = :should
  end
end

# Stub ActiveRecord
module ActiveRecord
  class Base
    def self.transaction
      yield if block_given?
    end
  end
end
