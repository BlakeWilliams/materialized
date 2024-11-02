# frozen_string_literal: true

require 'test_helper'
require 'active_model'

class Materialized::TrackerTest < Minitest::Test
  def test_can_persist_creation
    Post.create(title: 'Hello world')

    assert_equal 1, Log.count
    log = Log.first

    assert_equal 'create', log.action
    assert_equal [], log.fields
  end

  def test_can_persist_updates
    post = Post.create(title: 'Hello world')
    Log.destroy_all

    post.update(title: 'new title!')

    assert_equal 1, Log.count
    log = Log.first

    assert_equal 'update', log.action
    assert_equal %w[title updated_at], log.fields
  end

  def test_can_persist_destroy
    post = Post.create(title: 'Hello world')
    Log.destroy_all
    post.destroy

    assert_equal 1, Log.count
    log = Log.first

    assert_equal 'destroy', log.action
    assert_equal [], log.fields
  end
end
