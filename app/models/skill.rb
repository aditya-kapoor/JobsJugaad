class Skill < ActiveRecord::Base
  attr_accessible :name
  # belongs_to :key_skill, :polymorphic => true

  has_many :xyz
  has_many :jobs, :through => :xyz, :source => :skillable, :source_type => 'Job'
  has_many :job_seekers, :through => :xyz, :source => :skillable, :source_type => 'JobSeeker'

  scope :skill_name, lambda { |name| where("name like ?", name)}
  scope :skill_type, lambda { |type| where("key_skill_type = ?", type)}
end
