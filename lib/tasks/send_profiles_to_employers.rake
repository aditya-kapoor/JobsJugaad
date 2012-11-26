desc "Sends out profiles of the Job Seekers to the employers"
task :send_profiles_to_employer => :environment do
  Employer.scoped.each do |employer|
    temp = []
    JobSeeker.all.each do |job_seeker|
      temp << job_seeker
    end
    puts "Sending Job Profiles for #{employer.name}"
    Notifier.send_profiles_to_employer(employer, temp).deliver
  end
end

