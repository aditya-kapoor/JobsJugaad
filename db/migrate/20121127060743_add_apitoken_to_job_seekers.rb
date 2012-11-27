class AddApitokenToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :apitoken, :string
    add_column :employers, :apitoken, :string
  end
end
