class AddAuthTokenToJobSeekers < ActiveRecord::Migration
  def change
    add_column :job_seekers, :auth_token, :string
    add_column :job_seekers, :activated, :boolean
    add_column :employers, :auth_token, :string
    add_column :employers, :activated, :boolean
  end
end
