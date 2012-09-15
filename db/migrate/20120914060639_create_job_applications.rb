class CreateJobApplications < ActiveRecord::Migration
  def change
    create_table :job_applications do |t|
      t.date :interview_on
      t.text :remarks
      t.integer :job_id
      t.integer :job_seeker_id
      
      t.timestamps
    end
  end
end
