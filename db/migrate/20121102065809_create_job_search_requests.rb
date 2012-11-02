class CreateJobSearchRequests < ActiveRecord::Migration
  def change
    create_table :job_search_requests do |t|
      t.string :location
      t.string :skills
      t.float :sal_min
      t.float :sal_max
      t.string :sal_type
      t.float :duration

      t.timestamps
    end
  end
end
