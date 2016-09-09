module Locomotive
  module Steam
    module Liquid
      module Drops
        class Base < ::Liquid::Drop

          @@forbidden_attributes = %w{_id _version _index}

          def initialize(source)
            @_source = source
          end

          def id
            (@_source.respond_to?(:id) ? @_source.id : nil) || 'new'
          end

          # converts an array of records to an array of liquid drops
          def self.liquify(*records, &block)
            i = -1
            records =
              records.inject [] do |all, r|
                i+=1
                attrs = (block && block.arity == 1) ? [r] : [r, i]
                all << (block ? block.call(*attrs) : r.to_liquid)
                all
              end
            records.compact!
            records
          end

          def as_json(options = nil)
            @_source.as_json(options)
          end

          protected

          def liquify(*records, &block)
            self.class.liquify(*records, &block)
          end

          def _source
            @_source
          end

        end
      end
    end
  end
end
