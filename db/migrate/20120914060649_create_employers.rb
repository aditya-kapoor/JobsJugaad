class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :email
      t.string :website
      t.text :description
      t.string :password_digest
      
      t.timestamps
    end
  end
end
