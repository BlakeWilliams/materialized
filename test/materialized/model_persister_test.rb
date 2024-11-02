# frozen_string_literal: true

require 'test_helper'
require 'active_model'

class Materialized::ModelPersisterTest < Minitest::Test
  def test_can_handle_string_model_values
    post = Post.create
    # TODO: refactor to have helper method to avoid creating logs entirely
    Log.destroy_all

    persister = Materialized::ModelPersister.new(model: 'Log')
    persister.persist(post, :create)

    assert_equal 1, Log.count
  end

  def test_can_handle_string_model_classes
    post = Post.create
    # TODO: refactor to have helper method to avoid creating logs entirely
    Log.destroy_all

    persister = Materialized::ModelPersister.new(model: Log)
    persister.persist(post, :create)

    assert_equal 1, Log.count
  end
end
