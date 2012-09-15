module JobSeekersHelper
  
  def get_errors(parameter)
    str = "" 
    unless @job_seeker.errors[parameter.to_sym].empty?
      @job_seeker.errors[parameter.to_sym].each { |msg| str+=msg+", " }
    end
    str
  end

  def error_present?(parameter)
    @job_seeker.errors[parameter.to_sym].empty?
  end
end
