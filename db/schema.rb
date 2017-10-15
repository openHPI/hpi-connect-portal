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

ActiveRecord::Schema.define(version: 20171015134828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alumnis", force: :cascade do |t|
    t.string   "firstname",    limit: 255
    t.string   "lastname",     limit: 255
    t.string   "email",        limit: 255, null: false
    t.string   "alumni_email", limit: 255, null: false
    t.string   "token",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "job_offer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "configurables", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "configurables", ["name"], name: "index_configurables_on_name", using: :btree

  create_table "contacts", force: :cascade do |t|
    t.integer  "counterpart_id"
    t.string   "counterpart_type", limit: 255
    t.string   "name",             limit: 255
    t.string   "street",           limit: 255
    t.string   "zip_city",         limit: 255
    t.string   "email",            limit: 255
    t.string   "phone",            limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_educations", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "degree",      limit: 255
    t.string   "field",       limit: 255
    t.string   "institution", limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cv_jobs", force: :cascade do |t|
    t.integer  "student_id"
    t.string   "position",    limit: 255
    t.string   "employer",    limit: 255
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "current",                 default: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "employers", force: :cascade do |t|
    t.string   "name",                  limit: 255
    t.text     "description_de"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name",      limit: 255
    t.string   "avatar_content_type",   limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "activated",                         default: false, null: false
    t.string   "place_of_business",     limit: 255
    t.string   "website",               limit: 255
    t.string   "line_of_business",      limit: 255
    t.integer  "year_of_foundation"
    t.string   "number_of_employees",   limit: 255
    t.integer  "requested_package_id",              default: 0,     null: false
    t.integer  "booked_package_id",                 default: 0,     null: false
    t.integer  "single_jobs_requested",             default: 0,     null: false
    t.string   "token",                 limit: 255
    t.text     "description_en"
  end

  add_index "employers", ["name"], name: "index_employers_on_name", unique: true, using: :btree

  create_table "employers_job_offers", id: false, force: :cascade do |t|
    t.integer "employer_id"
    t.integer "job_offer_id"
  end

  add_index "employers_job_offers", ["employer_id", "job_offer_id"], name: "index_employers_job_offers_on_employer_id_and_job_offer_id", unique: true, using: :btree

  create_table "faqs", force: :cascade do |t|
    t.string   "question",   limit: 255
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "locale",     limit: 255
  end

  create_table "job_offers", force: :cascade do |t|
    t.text     "description_de"
    t.string   "title",                     limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.float    "time_effort"
    t.float    "compensation"
    t.integer  "employer_id"
    t.integer  "status_id"
    t.boolean  "flexible_start_date",                   default: false
    t.integer  "category_id",                           default: 0,     null: false
    t.integer  "state_id",                              default: 3,     null: false
    t.integer  "graduation_id",                         default: 2,     null: false
    t.boolean  "prolong_requested",                     default: false
    t.boolean  "prolonged",                             default: false
    t.datetime "prolonged_at"
    t.date     "release_date"
    t.string   "offer_as_pdf_file_name",    limit: 255
    t.string   "offer_as_pdf_content_type", limit: 255
    t.integer  "offer_as_pdf_file_size"
    t.datetime "offer_as_pdf_updated_at"
    t.integer  "student_group_id",                      default: 0,     null: false
    t.text     "description_en"
  end

  create_table "job_offers_languages", id: false, force: :cascade do |t|
    t.integer "job_offer_id"
    t.integer "language_id"
  end

  add_index "job_offers_languages", ["job_offer_id", "language_id"], name: "jo_l_index", unique: true, using: :btree

  create_table "job_offers_programming_languages", id: false, force: :cascade do |t|
    t.integer "job_offer_id"
    t.integer "programming_language_id"
  end

  add_index "job_offers_programming_languages", ["job_offer_id", "programming_language_id"], name: "jo_pl_index", unique: true, using: :btree

  create_table "job_offers_students", id: false, force: :cascade do |t|
    t.integer "job_offer_id"
    t.integer "student_id"
  end

  add_index "job_offers_students", ["job_offer_id", "student_id"], name: "jo_s_index", unique: true, using: :btree

  create_table "job_statuses", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages_users", force: :cascade do |t|
    t.integer "student_id"
    t.integer "language_id"
    t.integer "skill"
  end

  create_table "newsletter_orders", force: :cascade do |t|
    t.integer  "student_id"
    t.text     "search_params"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "programming_languages", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",                default: false
  end

  create_table "programming_languages_users", force: :cascade do |t|
    t.integer "student_id"
    t.integer "programming_language_id"
    t.integer "skill"
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "student_id"
    t.integer "employer_id"
    t.integer "job_offer_id"
    t.string  "headline",                limit: 255
    t.text    "description"
    t.integer "score_overall"
    t.integer "score_atmosphere"
    t.integer "score_salary"
    t.integer "score_work_life_balance"
    t.integer "score_work_contents"
  end

  add_index "ratings", ["employer_id"], name: "index_ratings_on_employer_id", using: :btree
  add_index "ratings", ["job_offer_id"], name: "index_ratings_on_job_offer_id", using: :btree
  add_index "ratings", ["student_id"], name: "index_ratings_on_student_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "level"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staffs", force: :cascade do |t|
    t.integer  "employer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", force: :cascade do |t|
    t.integer  "semester"
    t.string   "academic_program",       limit: 255
    t.text     "education"
    t.text     "additional_information"
    t.date     "birthday"
    t.string   "homepage",               limit: 255
    t.string   "github",                 limit: 255
    t.string   "facebook",               limit: 255
    t.string   "xing",                   limit: 255
    t.string   "linkedin",               limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "employment_status_id",               default: 0, null: false
    t.integer  "frequency",                          default: 1, null: false
    t.integer  "academic_program_id",                default: 0, null: false
    t.integer  "graduation_id",                      default: 0, null: false
    t.integer  "visibility_id",                      default: 0, null: false
    t.integer  "dschool_status_id",                  default: 0, null: false
    t.integer  "group_id",                           default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",              limit: 255, default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "lastname",           limit: 255
    t.string   "firstname",          limit: 255
    t.string   "photo_file_name",    limit: 255
    t.string   "photo_content_type", limit: 255
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "cv_file_name",       limit: 255
    t.string   "cv_content_type",    limit: 255
    t.integer  "cv_file_size"
    t.datetime "cv_updated_at"
    t.integer  "status"
    t.integer  "manifestation_id"
    t.string   "manifestation_type", limit: 255
    t.string   "password_digest",    limit: 255
    t.boolean  "activated",                      default: false, null: false
    t.boolean  "admin",                          default: false, null: false
    t.string   "alumni_email",       limit: 255, default: "",    null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
