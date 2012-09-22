# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120922120236) do

  create_table "employers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.text     "description"
    t.string   "password_digest"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "auth_token"
    t.boolean  "activated"
    t.string   "password_reset_token"
  end

  create_table "job_applications", :force => true do |t|
    t.date     "interview_on"
    t.text     "remarks"
    t.integer  "job_id"
    t.integer  "job_seeker_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "job_seekers", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "location"
    t.string   "mobile_number"
    t.string   "experience"
    t.string   "industry"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "gender"
    t.date     "date_of_birth"
    t.string   "resume_file_name"
    t.string   "resume_content_type"
    t.integer  "resume_file_size"
    t.datetime "resume_updated_at"
    t.string   "auth_token"
    t.boolean  "activated"
    t.string   "password_reset_token"
  end

  create_table "jobs", :force => true do |t|
    t.text     "description"
    t.string   "location"
    t.integer  "employer_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "salary_min"
    t.integer  "salary_max"
    t.string   "title"
    t.string   "salary_type"
  end

  create_table "skills", :force => true do |t|
    t.string   "name"
    t.integer  "key_skill_id"
    t.string   "key_skill_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
