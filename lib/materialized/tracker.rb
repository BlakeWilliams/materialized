# frozen_string_literal: true

module Materialized
  module Tracker
    def self.included(mod)
      mod.extend(ClassMethods)
    end

    # :nodoc:
    module ClassMethods
      def materialize_with(persister, *args, **kwargs)
        raise ArgumentError, 'materialized models must respond to `after_save`' unless respond_to?(:after_save)

        unless instance_methods.include?(:previous_changes)
          raise ArgumentError,
                'materialized model instances must respond to `previous_changes`'
        end

        @__materialized_persister = persister.new(*args, **kwargs)

        class_eval do
          after_create -> { _materialized_track(:create) }
          after_update -> { _materialized_track(:update) }
          after_destroy -> { _materialized_track(:destroy) }
        end
      end

      def materialized_persister
        @__materialized_persister
      end
    end

    def _materialized_track(action)
      self.class.materialized_persister&.persist(self, action)
    end
  end
end
