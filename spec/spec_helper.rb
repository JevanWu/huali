require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # load simplecov before load Rails Application
  require 'simplecov'
  SimpleCov.start 'rails'

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'email_spec'

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.fail_fast = false

    # only use the should configuration
    config.expect_with :rspec do |c|
      c.syntax = :should
    end

    # Devise Helper for sign_in and sign_out
    config.include Devise::TestHelpers, :type => :controller

    # FactoryGirl
    config.include FactoryGirl::Syntax::Methods

    config.include(EmailSpec::Helpers)
    config.include(EmailSpec::Matchers)

    # config.fixture_path = "#{::Rails.root}/spec/fixtures"
    # config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false

    # Run specs in random order to surface order dependencies. If you find an
    # order dependency and want to debug it, you can fix the order by providing
    # the seed, which is printed after each run.
    #     --seed 1234
    config.order = "random"

    # For resetting database to a pristine state
    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  # FactoryGirl.reload
end
