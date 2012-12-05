desc "Sends out profiles of the Job Seekers to the employers"
task :send_profiles_to_employer => :environment do
  Employer.scoped.each do |employer|
    selected_profiles = []
    JobSeeker.all.each do |job_seeker|
      selected_profiles << job_seeker
    end
    puts "Sending Job Profiles for #{employer.name}"
    Notifier.delay.send_profiles_to_employer(employer, selected_profiles)
  end
end

