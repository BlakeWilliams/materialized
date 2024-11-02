# frozen_string_literal: true

module Materialized
  module Tracker
    def self.included(mod)
      raise ArgumentError, 'Materialized can only be included on model like objects' unless mod.respond_to?(:after_save)

      mod.extend(ClassMethods)

      mod.class_eval do
        after_save :_materialized_track
      end
    end

    # :nodoc:
    module ClassMethods
      def persist_with(persister, *args, **kwargs)
        @__materialized_persister = persister.new(*args, **kwargs)
      end

      def materialized_persister
        @__materialized_persister
      end
    end

    def _materialized_track
      self.class.materialized_persister.persist(self)
    end
  end
end
