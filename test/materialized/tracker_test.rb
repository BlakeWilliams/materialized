# frozen_string_literal: true

require 'test_helper'
require 'active_model'

# The model we're using to power the tracker
class MyModel
  # Implementing the common AR interface
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Dirty
  extend ActiveModel::Callbacks
  define_model_callbacks :save

  # What we're testing
  include Materialized::Tracker
  persist_with Materialized::ModelPersister, model: 'PersistenceModel'

  attribute :id, :integer
  attribute :title, :string
  attribute :body, :string

  def save
    run_callbacks :save do
      # Your create action methods here
    end
  end
end

class PersistenceModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  include Materialized::Model

  attribute :id, :integer
  attribute :type, :string
  attribute :fields, :string
  attribute :persisted_at, :datetime

  def self.store
    @_store ||= []
  end

  def save
    self.class.store << self
  end
end

class MaterializedTest < Minitest::Test
  def test_can_persist_changes
    MyModel.new(title: 'The truth is out there').save

    assert_equal 1, PersistenceModel.store.count
    persisted = PersistenceModel.store[0]
    assert_equal ['title'], persisted.fields
  end
end
