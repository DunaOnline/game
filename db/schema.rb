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

ActiveRecord::Schema.define(:version => 22) do

  create_table "app_logy", :force => true do |t|
    t.datetime "cas",                      :null => false
    t.string   "login",      :limit => 50
    t.integer  "login_id"
    t.string   "controller",               :null => false
    t.string   "action",                   :null => false
    t.integer  "action_id"
    t.text     "session"
    t.text     "params"
    t.text     "referer"
    t.integer  "duration"
  end

  create_table "buildings", :force => true do |t|
    t.string   "kind",                                                             :null => false
    t.integer  "level",                                                            :null => false
    t.string   "name",                                                             :null => false
    t.text     "description",                                     :default => ""
    t.decimal  "population_bonus", :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "pop_limit_bonus",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_bonus",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_bonus",   :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_bonus",      :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_bonus",        :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "population_cost",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_cost",     :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_cost",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_cost",       :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_cost",         :precision => 12, :scale => 4, :default => 0.0
    t.integer  "prerequisity_1"
    t.integer  "prerequisity_2"
    t.integer  "prerequisity_3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "buildings", ["kind"], :name => "index_buildings_on_kind"
  add_index "buildings", ["level"], :name => "index_buildings_on_level"
  add_index "buildings", ["name"], :name => "index_buildings_on_name"

  create_table "discoverables", :force => true do |t|
    t.string   "name",                              :null => false
    t.integer  "planet_type_id",                    :null => false
    t.string   "system_name",    :default => ""
    t.integer  "position"
    t.boolean  "discovered",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "effects", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.decimal  "population_bonus", :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "pop_limit_bonus",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_bonus",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_bonus",   :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_bonus",      :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_bonus",        :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "duration",         :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "population_cost",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_cost",     :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_cost",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_cost",       :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_cost",         :precision => 12, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "effects", ["name"], :name => "index_effects_on_name"

  create_table "environments", :force => true do |t|
    t.integer  "planet_id",                             :null => false
    t.integer  "property_id",                           :null => false
    t.date     "started_at",  :default => '2012-03-21'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "environments", ["planet_id"], :name => "index_environments_on_planet_id"
  add_index "environments", ["property_id"], :name => "index_environments_on_property_id"
  add_index "environments", ["started_at"], :name => "index_environments_on_started_at"

  create_table "eods", :force => true do |t|
    t.integer  "user_id",                                                                              :null => false
    t.integer  "field_id"
    t.date     "date",                                              :default => '2012-03-21',          :null => false
    t.time     "time",                                              :default => '2000-01-01 08:31:25', :null => false
    t.integer  "order",                                                                                :null => false
    t.integer  "solar_income",                                      :default => 0
    t.integer  "exp_income",                                        :default => 0
    t.decimal  "material_income",    :precision => 12, :scale => 4, :default => 0.0
    t.integer  "population_income",                                 :default => 0
    t.integer  "solar_expense",                                     :default => 0
    t.integer  "exp_expense",                                       :default => 0
    t.decimal  "material_expense",   :precision => 12, :scale => 4, :default => 0.0
    t.integer  "population_expense",                                :default => 0
    t.decimal  "melange_income",     :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_expense",    :precision => 12, :scale => 4, :default => 0.0
    t.integer  "solar_store",                                       :default => 0
    t.integer  "exp_store",                                         :default => 0
    t.decimal  "material_store",     :precision => 12, :scale => 4, :default => 0.0
    t.integer  "population_store",                                  :default => 0
    t.decimal  "melange_store",      :precision => 12, :scale => 4, :default => 0.0
    t.integer  "imperator"
    t.integer  "arrakis"
    t.integer  "leader"
    t.string   "mentats"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "estates", :force => true do |t|
    t.integer  "building_id",                :null => false
    t.integer  "field_id",                   :null => false
    t.integer  "number",      :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "estates", ["building_id"], :name => "index_estates_on_building_id"
  add_index "estates", ["field_id"], :name => "index_estates_on_field_id"

  create_table "fields", :force => true do |t|
    t.integer  "user_id"
    t.integer  "planet_id",                   :null => false
    t.string   "name",                        :null => false
    t.decimal  "pos_x",      :default => 0.0
    t.decimal  "pos_y",      :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fields", ["planet_id"], :name => "index_fields_on_planet_id"
  add_index "fields", ["user_id"], :name => "index_fields_on_user_id"

  create_table "globals", :force => true do |t|
    t.string   "setting",                                   :null => false
    t.boolean  "value"
    t.date     "datum"
    t.string   "slovo"
    t.decimal  "cislo",      :precision => 12, :scale => 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "houses", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.string   "leader"
    t.decimal  "solar",           :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange",         :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material",        :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp",             :precision => 12, :scale => 4, :default => 0.0
    t.boolean  "playable",                                       :default => true
    t.decimal  "melange_percent", :precision => 12, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "influence"
  end

  add_index "houses", ["name"], :name => "index_houses_on_name"

  create_table "influences", :force => true do |t|
    t.integer  "effect_id",                            :null => false
    t.integer  "field_id",                             :null => false
    t.date     "started_at", :default => '2012-03-21'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "influences", ["effect_id"], :name => "index_influences_on_effect_id"
  add_index "influences", ["field_id"], :name => "index_influences_on_field_id"
  add_index "influences", ["started_at"], :name => "index_influences_on_started_at"

  create_table "operations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "house_id"
    t.integer  "subhouse_id"
    t.string   "kind"
    t.string   "content"
    t.date     "date",        :default => '2012-05-11'
    t.time     "time",        :default => '2000-01-01 10:12:15'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planet_types", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.decimal  "fields",           :precision => 4,  :scale => 0, :default => 0
    t.decimal  "population_bonus", :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "pop_limit_bonus",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_bonus",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_bonus",   :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_bonus",      :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_bonus",        :precision => 12, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planet_types", ["name"], :name => "index_planet_types_on_name"

  create_table "planets", :force => true do |t|
    t.string   "name",                                       :null => false
    t.integer  "planet_type_id",                             :null => false
    t.integer  "house_id"
    t.string   "system_name"
    t.integer  "position"
    t.boolean  "available_to_all", :default => false
    t.date     "discovered_at",    :default => '2012-03-21'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planets", ["house_id"], :name => "index_planets_on_house_id"
  add_index "planets", ["name"], :name => "index_planets_on_name"
  add_index "planets", ["planet_type_id"], :name => "index_planets_on_planet_type_id"

  create_table "properties", :force => true do |t|
    t.string   "name",                                                             :null => false
    t.decimal  "population_bonus", :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "pop_limit_bonus",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_bonus",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_bonus",   :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_bonus",      :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_bonus",        :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "duration",         :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "population_cost",  :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange_cost",     :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material_cost",    :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "solar_cost",       :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp_cost",         :precision => 12, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "properties", ["name"], :name => "index_properties_on_name"

  create_table "resources", :force => true do |t|
    t.integer  "user_id"
    t.integer  "field_id"
    t.decimal  "population", :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "material",   :precision => 12, :scale => 4, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "subhouses", :force => true do |t|
    t.string   "name"
    t.integer  "house_id"
    t.integer  "solar"
    t.decimal  "melange"
    t.decimal  "material"
    t.integer  "exp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "subhouses", ["house_id"], :name => "index_subhouses_on_house_id"
  add_index "subhouses", ["name"], :name => "index_subhouses_on_name"

  create_table "systems", :force => true do |t|
    t.string   "system_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                                                        :null => false
    t.string   "nick",                                                            :null => false
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.integer  "house_id",                                                        :null => false
    t.integer  "subhouse_id"
    t.decimal  "solar",         :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "melange",       :precision => 12, :scale => 4, :default => 0.0
    t.decimal  "exp",           :precision => 12, :scale => 4, :default => 0.0
    t.boolean  "leader",                                       :default => false
    t.boolean  "mentat",                                       :default => false
    t.boolean  "army_mentat",                                  :default => false
    t.boolean  "diplomat",                                     :default => false
    t.boolean  "general",                                      :default => false
    t.boolean  "vicegeneral",                                  :default => false
    t.boolean  "landsraad",                                    :default => false
    t.boolean  "arrakis",                                      :default => false
    t.boolean  "emperor",                                      :default => false
    t.boolean  "regent",                                       :default => false
    t.boolean  "court",                                        :default => false
    t.boolean  "vezir",                                        :default => false
    t.boolean  "admin",                                        :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "influence"
  end

  add_index "users", ["house_id"], :name => "index_users_on_house_id"
  add_index "users", ["subhouse_id"], :name => "index_users_on_subhouse_id"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "votes", :force => true do |t|
    t.integer  "house_id",   :null => false
    t.integer  "elector",    :null => false
    t.integer  "elective",   :null => false
    t.string   "typ",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
