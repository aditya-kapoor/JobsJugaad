class Xyz < ActiveRecord::Base
  attr_accessible :skill_id, :skillable_id, :skillable_type
  belongs_to :skillable, :polymorphic => true
  belongs_to :skill
end
