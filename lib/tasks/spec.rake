desc "Run all spec one by one, which would be used in CI server"
namespace :spec do
  task all: [:components,
             :controllers,
             :decorators,
             :helpers,
             :mailers,
             :models,
             :requests,
             :routing,
             :services,
             :values,
             :features]
end
