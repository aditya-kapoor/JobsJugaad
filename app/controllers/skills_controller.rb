class SkillsController < ApplicationController
  def index
    @skills = Skill.find(:all, :conditions => ['name like ?', "%#{params[:search]}%"])
  end
end
