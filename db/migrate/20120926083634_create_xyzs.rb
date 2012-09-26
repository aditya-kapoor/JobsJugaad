class CreateXyzs < ActiveRecord::Migration
  def change
    create_table :xyzs do |t|
      t.integer :skillable_id
      t.string :skillable_type
      t.integer :skill_id

      t.timestamps
    end
  end
end
