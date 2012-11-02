class AddTwitterAccessTokentoEmployer < ActiveRecord::Migration
  def change 
    add_column :employers, :oauth_access_token, :string
    add_column :employers, :oauth_access_token_secret, :string
  end
end
