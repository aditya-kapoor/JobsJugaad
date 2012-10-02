class Skill < ActiveRecord::Base
  attr_accessible :name
  # belongs_to :key_skill, :polymorphic => true

  # has_many :xyz
  # has_many :jobs, :through => :xyz, :source => :skillable, :source_type => 'Job'
  # has_many :job_seekers, :through => :xyz, :source => :skillable, :source_type => 'JobSeeker'

  has_many :skillsassociation
  has_many :jobs, :through => :skillsassociation, :source => :skillable, :source_type => 'Job'
  has_many :job_seekers, :through => :skillsassociation, :source => :skillable, :source_type => 'JobSeeker'  

  validates :name, :presence => true
  validates :name, :uniqueness => true, :unless => proc { |skill| skill.name.blank? }
  scope :skill_name, lambda { |name| where("name like ?", name)}
end
