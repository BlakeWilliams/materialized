# frozen_string_literal: true

require 'active_support'
require 'json'
require_relative 'materialized/builder'
require_relative 'materialized/version'
require_relative 'materialized/model'
require_relative 'materialized/tracker'
require_relative 'materialized/model_persister'

module Materialized
  class Error < StandardError; end
end
