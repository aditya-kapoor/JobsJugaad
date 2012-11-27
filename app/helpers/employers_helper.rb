module EmployersHelper
  def check_for_token
    unless @employer.apitoken.blank?
      "API Token = #{@employer.apitoken}"
    else
      link_to 'Register for a token', get_api_token_employer_path(@employer)
    end
  end
end
