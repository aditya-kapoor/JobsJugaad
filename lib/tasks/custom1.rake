task :greet do 
  puts "Hello World !!!"
end

task :ask => :greet do 
  puts "Howdyy"
end

namespace :pick do

  desc "Picks Random JobSeeker"
  task :winner => :environment do 
    puts "Winner : #{pick(JobSeeker).name}"
  end

  desc "Picks Random Job"
  task :job => :environment do 
    puts "Random Job: #{pick(Job).title}"
  end

  desc "Prints Random Job and Seeker"
  task :all => [:winner, :job]

  def pick(model)
    model.find(:first, :order => 'RAND()')
  end
end