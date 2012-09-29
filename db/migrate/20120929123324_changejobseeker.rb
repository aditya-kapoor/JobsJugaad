class Changejobseeker < ActiveRecord::Migration
  def up
    change_table :job_seekers do |t|
      t.change :gender, :integer
    end
  end

  def down
    change_table :job_seekers do |t|
      t.change :gender, :string
    end
  end
end
