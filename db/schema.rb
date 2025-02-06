# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_02_01_223232) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "value", limit: 45
    t.bigint "question_id", null: false
    t.bigint "questionnaire_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["questionnaire_id"], name: "index_answers_on_questionnaire_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string "code", limit: 45, null: false
    t.string "semester", limit: 45, null: false
    t.bigint "subject_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subject_id"], name: "index_classrooms_on_subject_id"
  end

  create_table "coordinators", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_coordinators_on_department_id"
    t.index ["user_id"], name: "index_coordinators_on_user_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", limit: 45
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "classroom_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["classroom_id"], name: "index_enrollments_on_classroom_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "question_options", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "text", limit: 45
    t.bigint "question_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_options_on_question_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "classroom_info", limit: 100
    t.bigint "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questionnaires_on_template_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "text", limit: 255
    t.string "question_type", limit: 45
    t.bigint "template_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["template_id"], name: "index_questions_on_template_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "code", limit: 45
    t.string "time", limit: 10
    t.bigint "department_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_subjects_on_department_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "questionnaire_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_submissions_on_questionnaire_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "name", limit: 45
    t.string "target_audience", limit: 45
    t.string "semester", limit: 45
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "matricula", null: false
    t.string "nome", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "answers", "questionnaires"
  add_foreign_key "answers", "questions"
  add_foreign_key "classrooms", "subjects"
  add_foreign_key "coordinators", "departments"
  add_foreign_key "coordinators", "users"
  add_foreign_key "enrollments", "classrooms"
  add_foreign_key "enrollments", "users"
  add_foreign_key "question_options", "questions"
  add_foreign_key "questionnaires", "templates"
  add_foreign_key "questions", "templates"
  add_foreign_key "subjects", "departments"
  add_foreign_key "submissions", "questionnaires"
  add_foreign_key "submissions", "users"
end
