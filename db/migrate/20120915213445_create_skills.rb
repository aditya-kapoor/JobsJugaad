class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :key_skill_id
      t.string :key_skill_type
      
      t.timestamps
    end
  end
end
