DatabaseCleaner.strategy = :deletion, {:except => %w[spatial_ref_sys]}
DatabaseCleaner.clean_with :truncation, {:except => %w[spatial_ref_sys]}
Cucumber::Rails::Database.javascript_strategy = :truncation, { :except=>%w[spatial_ref_sys] }
