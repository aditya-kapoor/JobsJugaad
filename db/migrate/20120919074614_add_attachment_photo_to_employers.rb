class AddAttachmentPhotoToEmployers < ActiveRecord::Migration
  def self.up
    add_column :employers, :photo_file_name, :string
    add_column :employers, :photo_content_type, :string
    add_column :employers, :photo_file_size, :integer
    add_column :employers, :photo_updated_at, :datetime
  end

  def self.down
    remove_column :employers, :photo_file_name
    remove_column :employers, :photo_content_type
    remove_column :employers, :photo_file_size
    remove_column :employers, :photo_updated_at
  end
end
