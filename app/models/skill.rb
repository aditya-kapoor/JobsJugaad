class Skill < ActiveRecord::Base
  attr_accessible :name
  belongs_to :key_skill, :polymorphic => true

  scope :skill_name, lambda { |name| where("name = ?", name)}
  scope :skill_type, lambda { |type| where("key_skill_type = ?", type)}
end
