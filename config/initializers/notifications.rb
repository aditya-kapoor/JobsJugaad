ActiveSupport::Notifications.subscribe "jobs.search" do |name, start, finish, id, payload|
  Rails.logger.debug("SEARCH happened : #{payload}")
  Rails.logger.debug(["notification:", name, start, finish, id, payload].join(" "))
  # Rails.logger.debug("Location : #{payload[:search][:location]}")
  # Rails.logger.debug("Skills : #{payload[:search][:skills]}")
  # Rails.logger.debug("Salary Min. : #{payload[:search][:salary_min]}")
  # Rails.logger.debug("Salary Max. : #{payload[:search][:salary_max]}")
  # Rails.logger.debug("Salary Max. : #{payload[:search][:salary_type]}")
  # Rails.logger.debug("Duration of Request : #{(finish - start) * 1000 }")

  JobSearchRequests.create! do |job_search|
    job_search.location = payload[:search][:location]
    job_search.skills = payload[:search][:skills]
    job_search.sal_min = payload[:search][:salary_min]
    job_search.sal_max = payload[:search][:salary_max]
    job_search.sal_type = payload[:search][:salary_type]
    job_search.duration = (finish - start) * 1000
  end
end