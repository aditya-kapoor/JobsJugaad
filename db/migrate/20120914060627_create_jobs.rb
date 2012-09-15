class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.text :description
      t.string :location
      t.string :keywords
      t.string :skill_set
      t.integer :salary
      t.integer :employer_id
      t.timestamps
    end
  end
end
