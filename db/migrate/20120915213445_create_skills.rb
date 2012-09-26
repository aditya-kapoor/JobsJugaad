class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :name
      t.integer :skillable_id
      t.string :skillable_type
      
      t.timestamps
    end
  end
end
