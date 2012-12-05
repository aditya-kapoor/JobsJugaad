desc "Sends out the job notifications to the desired candidates"
task :send_email_notifications => :environment do
  JobSeeker.includes(:jobs, [:skills => :jobs]).scoped.each do |job_seeker|
    selected_jobs = []
    job_seeker.skills.each do |skill|
      skill.jobs.each do |job|
        unless job_seeker.jobs.include? job
          selected_jobs << job
        end
      end
    end
    puts "Sending Recommended jobs for #{job_seeker.name} :"
    Notifier.delay.send_job_alerts(job_seeker, selected_jobs)
  end
end
