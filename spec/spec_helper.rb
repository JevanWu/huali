# spec_helper.rb is used for acceptance tests
# it preloads rails and database related test components

require 'spork'
require 'rr'
require 'capybara/rspec'
#Capybara.javascript_driver = :selenium

# poltergeist
#require 'capybara/poltergeist'
#Capybara.register_driver :poltergeist do |app|
  #Capybara::Poltergeist::Driver.new(app, js_errors: false, phantomjs_options: ["--proxy=127.0.0.1:8087"])
#end
#Capybara.javascript_driver = :poltergeist

# chrome driver
Capybara.register_driver :chrome do |app|
  proxy = { proxyType: 'pac', proxyAutoconfigUrl: 'http://127.0.0.1:8086/proxy.pac' }
  Capybara::Selenium::Driver.new(app, browser: :chrome, proxy: proxy)
end
Capybara.javascript_driver = :chrome
#Capybara.default_driver = :chrome

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # load simplecov before load Rails Application
  require 'simplecov'
  SimpleCov.start 'rails'

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)

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

    # Devise Helper for sign_in, sign_out, login_<user>
    config.include Devise::TestHelpers, type: [:controller, :request]
    config.extend ControllerMacros, type: [:controller, :request]

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
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
      set_selenium_window_size(1250, 800) if Capybara.current_driver == :selenium
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

def set_selenium_window_size(width, height)
  window = Capybara.current_session.driver.browser.manage.window
  window.resize_to(width, height)
end

Spork.each_run do
  FactoryGirl.reload
  Dir["app/inputs/*_input.rb"].each { |f| require File.basename(f) }
end
