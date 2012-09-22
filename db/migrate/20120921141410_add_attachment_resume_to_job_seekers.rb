class AddAttachmentResumeToJobSeekers < ActiveRecord::Migration
  def self.up
    add_column :job_seekers, :resume_file_name, :string
    add_column :job_seekers, :resume_content_type, :string
    add_column :job_seekers, :resume_file_size, :integer
    add_column :job_seekers, :resume_updated_at, :datetime
  end

  def self.down
    remove_column :job_seekers, :resume_file_name
    remove_column :job_seekers, :resume_content_type
    remove_column :job_seekers, :resume_file_size
    remove_column :job_seekers, :resume_updated_at
  end
end
