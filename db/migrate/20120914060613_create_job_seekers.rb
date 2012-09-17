class CreateJobSeekers < ActiveRecord::Migration
  def change
    create_table :job_seekers do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :location
      t.string :mobile_number
      t.string :experience
      t.string :industry
      
      t.timestamps
    end
  end
end
