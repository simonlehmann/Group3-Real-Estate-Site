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

ActiveRecord::Schema.define(version: 20160413053732) do

  create_table "listings", force: :cascade do |t|
    t.string   "address",     limit: 255
    t.string   "suburb",      limit: 255
    t.string   "state",       limit: 255
    t.integer  "post_code",   limit: 4
    t.integer  "bedrooms",    limit: 4
    t.integer  "bathrooms",   limit: 4
    t.integer  "parking",     limit: 4
    t.integer  "land_size",   limit: 4
    t.string   "title",       limit: 255
    t.string   "subtitle",    limit: 255
    t.string   "description", limit: 255
    t.string   "price_type",  limit: 255
    t.integer  "price_min",   limit: 4
    t.integer  "price_max",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

end
