class AddPasswordResetTokenToTables < ActiveRecord::Migration
  def change
    add_column :job_seekers, :password_reset_token, :string
    add_column :employers, :password_reset_token, :string
  end
end
