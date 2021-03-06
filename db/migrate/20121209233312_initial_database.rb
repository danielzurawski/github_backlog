class InitialDatabase < ActiveRecord::Migration
  def change
    create_table "issues", :force => true do |t|
    t.string   "title"
    t.string   "state"
    t.string   "github_url"
    t.integer  "github_number"
    t.string   "github_assignee"
    t.integer  "user_story_identifier_id"
    t.integer  "repo_id"
    t.integer  "project_id"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "scope"
  end

  create_table "projects_users", :force => true do |t|
    t.integer "user_id"
    t.integer "project_id"
  end

  create_table "repos", :force => true do |t|
    t.string   "owner"
    t.text     "repo"
    t.datetime "last_check"
    t.integer  "project_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_stories", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "identifier"
    t.integer  "position"
    t.text     "acceptance_tests"
    t.text     "use_cases"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "user_story_type_id"
    t.integer  "user_story_status_id"
    t.boolean  "current_sprint"
    t.boolean  "next_sprint"
    t.boolean  "historized"
    t.datetime "historized_date"
  end

  create_table "user_story_statuses", :force => true do |t|
    t.string   "name"
    t.integer  "project_id"
    t.boolean  "closed"
    t.boolean  "default"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_story_types", :force => true do |t|
    t.integer  "project_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "email"
    t.string   "login"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "token"
  end
  end
end
