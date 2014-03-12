require 'spork'

ENV["RAILS_ENV"] ||= 'test'

Spork.prefork do
  require "rails/application"
  Spork.trap_method(Rails::Application, :reload_routes!)

  require File.expand_path("../../config/environment", __FILE__)

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'rr'
  require 'database_cleaner'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.fail_fast = false

    # only use the should configuration
    config.expect_with :rspec do |c|
      c.syntax = :should
    end

    # Run specs in random order to surface order dependencies.
    config.order = "random"

    # FactoryGirl Syntax Mixins
    config.include FactoryGirl::Syntax::Methods

    # For resetting database to a pristine state
    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end
  end
end

Spork.each_run do
  FactoryGirl.reload
end if Spork.using_spork?
