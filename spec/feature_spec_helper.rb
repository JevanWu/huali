# feature_spec_helper.rb is used for acceptance tests
# it preloads rails and database related test components

require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do

  require 'rr'
  require 'capybara/rspec'

  # chrome driver
  Capybara.register_driver :chrome do |app|
    proxy = { proxyType: 'pac', proxyAutoconfigUrl: "file:///#{::Rails.root}/spec/fixtures/SwitchyPac.pac" }
    Capybara::Selenium::Driver.new(app, browser: :chrome, proxy: proxy)
  end
  Capybara.javascript_driver = :chrome
  #Capybara.default_driver = :chrome

  # load simplecov before load Rails Application
  require 'simplecov'
  SimpleCov.start 'rails'

  # Use spork with active_admin https://github.com/gregbell/active_admin/wiki/Use-spork
  require "rails/application"
  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)

  # Eager load custom simple_form and formtastic inputs
  Dir["app/inputs/*_input.rb"].each { |f| require File.basename(f) }

  # tweak Rails for faster tests
  Rails.logger.level = 4

  require 'rspec/rails'
  require 'rspec/autorun'
  require 'capybara/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  require 'email_spec'

  RSpec.configure do |config|
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.fail_fast = false

    # only use the should configuration
    config.expect_with :rspec do |c|
      c.syntax = :should
    end

    # FactoryGirl Syntax Mixins
    config.include FactoryGirl::Syntax::Methods

    # Warden helper for stubbed login and logout
    config.include Warden::Test::Helpers, type: :feature

    config.include RegionRuleHelper, type: :feature
    config.include CustomCapybaraHelper, type: :feature

    # FactoryGirl Logging
    config.before(:suite) do
      @factory_girl_results = {}
      ActiveSupport::Notifications.subscribe("factory_girl.run_factory") do |name, start, finish, id, payload|
        execution_time_in_seconds = finish - start

        if execution_time_in_seconds >= 0.5
          $stderr.puts "Slow factory: #{payload[:name]} using strategy #{payload[:strategy]}"
        end

        factory_name = payload[:name]
        strategy_name = payload[:strategy]
        @factory_girl_results[factory_name] ||= {}
        @factory_girl_results[factory_name][strategy_name] ||= 0
        @factory_girl_results[factory_name][strategy_name] += 1
      end
    end

    config.after(:suite) do
      puts @factory_girl_results
      # http://stackoverflow.com/questions/13864286/rspec-spork-postgres-error-prepared-statement-a1-already-exists
      ActiveRecord::Base.connection.execute("DEALLOCATE ALL")
    end

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
      DatabaseCleaner.clean_with(:truncation)
    end

    config.around(:each) do |example|
      DatabaseCleaner.cleaning do
        example.run
      end
    end

    config.before(:each) do
      set_window_size(1024, 768) if Capybara.current_driver != :rack_test
    end

  end
end

Spork.each_run do
  FactoryGirl.reload
end if Spork.using_spork?
