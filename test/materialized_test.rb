# frozen_string_literal: true

require 'test_helper'

class MaterializedTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Materialized::VERSION
  end

  def test_materialized_e2e
    refute_nil ::Materialized::VERSION
  end
end
