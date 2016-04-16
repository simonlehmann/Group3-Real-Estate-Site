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

  create_table "blockages", primary_key: "BlockageID", force: :cascade do |t|
    t.integer  "BlockageToUserID",   limit: 4, null: false
    t.integer  "BlockageFromUserID", limit: 4, null: false
    t.datetime "BlockageCreatedAt",            null: false
  end

  create_table "favourites", primary_key: "FavouriteID", force: :cascade do |t|
    t.integer  "FavouriteUserID",    limit: 4, null: false
    t.integer  "FavouriteListingID", limit: 4, null: false
    t.datetime "FavouriteCreatedAt",           null: false
  end

  create_table "listing_images", primary_key: "ListingImageID", force: :cascade do |t|
    t.string   "ListingImagePath",       limit: 128, null: false
    t.string   "ListingImagePathLowRes", limit: 128, null: false
    t.datetime "ListingImageCreatedAt",              null: false
    t.integer  "ListingImageListingID",  limit: 4,   null: false
  end

  create_table "listing_status", primary_key: "ListingStatusID", force: :cascade do |t|
    t.string "ListingStatusLabel",     limit: 0, null: false
    t.date   "ListingStatusDate"
    t.time   "ListingStatusStartTime"
    t.time   "ListingStatusEndTime"
  end

  create_table "listings", primary_key: "ListingID", force: :cascade do |t|
    t.integer  "ListingCoverImageID", limit: 4
    t.string   "ListingAddress",      limit: 256,                                          null: false
    t.string   "ListingSuburb",       limit: 32,                                           null: false
    t.string   "ListingState",        limit: 0,                                            null: false
    t.integer  "ListingPostCode",     limit: 4,                                            null: false
    t.integer  "ListingBedrooms",     limit: 4,                                            null: false
    t.integer  "ListingBathrooms",    limit: 4,                                            null: false
    t.integer  "ListingParking",      limit: 4,                                            null: false
    t.integer  "ListingLandSize",     limit: 4,                                            null: false
    t.string   "ListingTitle",        limit: 64,                                           null: false
    t.string   "ListingSubtitle",     limit: 128,                                          null: false
    t.text     "ListingDescription",  limit: 65535,                                        null: false
    t.string   "ListingPriceType",    limit: 0,                              default: "F", null: false
    t.decimal  "ListingPriceMin",                   precision: 12, scale: 2,               null: false
    t.decimal  "ListingPriceMax",                   precision: 12, scale: 2,               null: false
    t.integer  "ListingStatusID",     limit: 4,                                            null: false
    t.integer  "ListingUserID",       limit: 4,                                            null: false
    t.integer  "ListingViews",        limit: 4,                              default: 0,   null: false
    t.integer  "ListingFavourites",   limit: 4,                              default: 0,   null: false
    t.integer  "ListingComments",     limit: 4,                              default: 0,   null: false
    t.datetime "ListingCreatedAt",                                                         null: false
    t.datetime "ListingUpdatedAt",                                                         null: false
    t.datetime "ListingToEndAt",                                                           null: false
    t.datetime "ListingEndedAt"
  end

  create_table "messages", primary_key: "MessageID", force: :cascade do |t|
    t.integer  "MessageToUserID",   limit: 4,     null: false
    t.integer  "MessageFromUserID", limit: 4,     null: false
    t.string   "MessageSubject",    limit: 128,   null: false
    t.text     "MessageBody",       limit: 65535, null: false
    t.datetime "MessageSentAt",                   null: false
  end

  create_table "tag_type", primary_key: "TagTypeID", force: :cascade do |t|
    t.string "TagTypeLabel",    limit: 50, null: false
    t.string "TagTypeCategory", limit: 25, null: false
  end

  create_table "tags", primary_key: "TagID", force: :cascade do |t|
    t.string   "TagLabel",     limit: 64, null: false
    t.integer  "TagTypeID",    limit: 4,  null: false
    t.integer  "TagListingID", limit: 4,  null: false
    t.datetime "TagCreatedAt",            null: false
  end

