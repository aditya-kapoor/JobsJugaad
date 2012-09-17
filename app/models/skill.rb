class Skill < ActiveRecord::Base
  attr_accessible :name
  belongs_to :key_skill, :polymorphic => true
end
