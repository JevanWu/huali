# interactor :off
interactor history_file: "#{ENV['HOME']}/.guard_history"

# bundle exec guard -g frontend
group :frontend do
  guard :bundler do
    watch('Gemfile')
    # Uncomment next line if Gemfile contain `gemspec' command
    # watch(/^.+\.gemspec/)
  end

  guard :pow do
    watch('.rvmrc')
    watch(%r{^\.pow(rc|env)$})
    watch('Gemfile.lock')
    watch(%r{^config/.+\.rb$})
  end

  guard :livereload, host: 'localhost', port: '35729' do
    watch(%r{app/.*/[^.][^/]+\.(erb|haml|slim)})
    watch(%r{app/helpers/.*/[^.][^/]+\.rb})
    watch(%r{public/(.*/[^.][^/]+\.(css|js|html))}) {|m| m[1] }
    watch(%r{app/assets/(.*/[^.][^/]+\.css)(\.s[ac]ss)?}) { |m| "/assets/#{m[1]}" }
    watch(%r{app/assets/(.*/[^.][^/]+\.js)(\.coffee)?}) { |m| "/assets/#{m[1]}" }
    watch(%r{config/locales/[^.].+\.yml})
  end

end

# bundle exec guard -g backend
group :backend do
  guard 'spork', wait: 60, cucumber: false do
    watch('Gemfile')
    watch('Gemfile.lock')
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb})
    watch(%r{^config/initializers/.+\.rb})
    watch('spec/spec_helper_full.rb')
    watch('config/routes.rb')
    watch(%r{^spec/support/.+\.rb})
  end

  guard :rspec, version: 2, cli: "--color --drb", bundler: false, all_after_pass: false, all_on_start: false, keep_failed: false do
    watch('spec/spec_helper_lite.rb')                                               { "spec" }
    watch('app/controllers/application_controller.rb')                         { "spec/controllers" }
    watch(%r{^spec/support/(requests|controllers|mailers|models)_helpers\.rb}) { |m| "spec/#{m[1]}" }
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.*)(\.erb|\.haml)$})                 { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }

    # watch for factory changes
    watch(%r{^spec/factories/.+\.rb$})                  { "spec/factories_spec.rb" }

    # watch for routing changes
    watch('config/routes.rb')                                                  { "spec/routing" }
    # watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
  end
end

