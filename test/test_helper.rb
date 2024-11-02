# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'materialized'

require 'active_record'
require 'minitest/pride'
require 'minitest/autorun'

unless ENV['DEBUG']
  ActiveRecord::Base.logger = nil
  ActiveRecord::Migration.verbose = false
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)

ActiveRecord::Schema.define do
  create_table 'posts', force: :cascade do |t|
    t.string   'title'
    t.text     'body'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'comments', force: :cascade do |t|
    t.text     'body'
    t.integer  'post_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'logs', force: :cascade do |t|
    t.string   'fields'
    t.string   'class_id'
    t.string   'class_name'
    t.string   'action'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'post_views', force: :cascade do |t|
    t.string      'title'
    t.integer     'comment_count'
    t.integer     'post_id'
  end
end

class ApplicationRecord < ActiveRecord::Base
  include Materialized::Tracker

  self.abstract_class = true
end

class Post < ApplicationRecord
  materialize_with Materialized::ModelPersister, model: 'Log'
end

class Comment < ApplicationRecord
  materialize_with Materialized::ModelPersister, model: 'Log'
end

class PostView < ApplicationRecord
  belongs_to :post
end

class Log < ApplicationRecord
  include Materialized::Model
end

class Minitest::Test
  def before_setup
    super

    Post.delete_all
    Log.delete_all
    PostView.delete_all
  end
end
