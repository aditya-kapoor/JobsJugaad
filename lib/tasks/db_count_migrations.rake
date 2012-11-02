namespace :db do 
  desc "Counts the number of migrations which are run till now"
  task :count_migrations => :environment do 
    puts ActiveRecord::Base.connection.select_values(
      'select count(*) from schema_migrations order by version'
      )
  end
end