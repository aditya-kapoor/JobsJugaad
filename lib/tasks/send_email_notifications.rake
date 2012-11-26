desc "Sends out the job notifications to the desired candidates"
task :send_email_notifications => :environment do
  JobSeeker.scoped.each do |job_seeker|
    temp = []
    job_seeker.skills.each do |skill|
      skill.jobs.each do |job|
        unless job_seeker.jobs.include? job
          temp << job
        end
      end
    end
    puts "Sending Recommended jobs for #{job_seeker.name} :"
    Notifier.send_job_alerts(job_seeker, temp).deliver
  end
end
