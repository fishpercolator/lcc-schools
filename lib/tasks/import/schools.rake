require 'schools/import/schools'

namespace :import do
  desc 'Import schools'
  task :schools => :environment do
    DEFAULT_SCHOOLS_CSV = 'data/All Schools Info - corrected.csv'
    Schools::Import::Schools.new(DEFAULT_SCHOOLS_CSV).run!
  end
end
