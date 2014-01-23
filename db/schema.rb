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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140121210237) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: true do |t|
    t.integer  "user_id"
    t.integer  "job_offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chairs_newsletter_informations", force: true do |t|
    t.integer "user_id"
    t.integer "chair_id"
  end

  create_table "employers", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "head",                                null: false
    t.integer  "deputy_id"
    t.boolean  "external",            default: false
  end

  add_index "employers", ["name"], name: "index_employers_on_name", unique: true, using: :btree

  create_table "employers_job_offers", id: false, force: true do |t|
    t.integer "employer_id"
    t.integer "job_offer_id"
  end

  add_index "employers_job_offers", ["employer_id", "job_offer_id"], name: "index_employers_job_offers_on_employer_id_and_job_offer_id", unique: true, using: :btree

  create_table "faqs", force: true do |t|
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_offers", force: true do |t|
    t.text     "description"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "time_effort"
    t.float    "compensation"
    t.string   "room_number"
    t.integer  "employer_id"
    t.integer  "responsible_user_id"
    t.integer  "status_id",           default: 1
    t.integer  "assigned_student_id"
  end

  create_table "job_offers_languages", id: false, force: true do |t|
    t.integer "job_offer_id"
    t.integer "language_id"
  end

  add_index "job_offers_languages", ["job_offer_id", "language_id"], name: "jo_l_index", unique: true, using: :btree

  create_table "job_offers_programming_languages", id: false, force: true do |t|
    t.integer "job_offer_id"
    t.integer "programming_language_id"
  end

  add_index "job_offers_programming_languages", ["job_offer_id", "programming_language_id"], name: "jo_pl_index", unique: true, using: :btree

  create_table "job_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_users", force: true do |t|
    t.integer "user_id"
    t.integer "language_id"
    t.integer "skill"
  end

  create_table "programming_languages", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programming_languages_newsletter_informations", force: true do |t|
    t.integer "user_id"
    t.integer "programming_language_id"
  end

  create_table "programming_languages_users", force: true do |t|
    t.integer "user_id"
    t.integer "programming_language_id"
    t.integer "skill"
  end

  create_table "roles", force: true do |t|
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_statuses", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "identity_url"
    t.string   "lastname"
    t.string   "firstname"
    t.integer  "role_id",                default: 1,  null: false
    t.integer  "employer_id"
    t.integer  "semester"
    t.string   "academic_program"
    t.date     "birthday"
    t.text     "education"
    t.text     "additional_information"
    t.string   "homepage"
    t.string   "github"
    t.string   "facebook"
    t.string   "xing"
    t.string   "linkedin"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "cv_file_name"
    t.string   "cv_content_type"
    t.integer  "cv_file_size"
    t.datetime "cv_updated_at"
    t.integer  "status"
    t.integer  "user_status_id"
    t.date     "employment_start_date"
    t.integer  "frequency",              default: 1,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
