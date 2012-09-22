class ChangesToTables < ActiveRecord::Migration
  def up
    change_table :job_seekers do |t|
      t.string :gender
      t.date :date_of_birth
    end
    change_table :jobs do |t|
      t.remove :salary, :keywords
      t.integer :salary_min
      t.integer :salary_max
      t.string :title
      t.string :salary_type
    end
  end

  def down
    change_table :job_seekers do |t|
      t.remove :gender, :date_of_birth
    end
    change_table :jobs do |t|
      t.remove :salary_max, :salary_min, :salary_type, :title
      t.integer :salary
      t.string :keywords
    end
  end
end
