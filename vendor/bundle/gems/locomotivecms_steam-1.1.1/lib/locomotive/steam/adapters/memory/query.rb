require 'forwardable'

module Locomotive::Steam
  module Adapters
    module Memory

      class Query

        include Enumerable
        extend  Forwardable

        def_delegators :all, :each, :last, :to_s, :to_a, :empty?, :size

        alias :length :size
        alias :count :size

        attr_reader :conditions

        def initialize(dataset, locale = nil, &block)
          @dataset    = dataset
          @conditions = []
          @sorting    = nil
          @limit      = nil
          @offset     = 0
          @locale     = locale
          instance_eval(&block) if block_given?
        end

        def where(conditions = {})
          @conditions += conditions.map { |name, value| Condition.new(name, value, @locale) }
          self
        end

        def +(query)
          @conditions += query.conditions
          self
        end

        def order_by(*args)
          @sorting = Order.new(*args)
        end

        def limit(num)
          @limit = num
          self
        end

        def offset(num)
          @offset = num
          self
        end

        def only(*fields)
          self
        end

        def ==(other)
          if other.kind_of? Array
            all == other
          else
            super
          end
        end

        def all
          # TODO: instrumentation here
          # Locomotive::Common::Logger.debug "[dataset][#{@dataset.name}] conditions = #{@conditions.map(&:inspect).join(' AND ')}"
          limited sorted(filtered)
        end

        def sorted(entries)
          return entries if @sorting.blank?

          entries.sort_by { |entry| @sorting.apply_to(entry, @locale) }
        end

        def limited(entries)
          return [] if @limit == 0
          return entries if @offset == 0 && @limit.nil?

          subentries = entries.drop(@offset || 0)
          if @limit.kind_of? Integer
            subentries.take(@limit)
          else
            subentries
          end
        end

        def filtered
          @dataset.all.dup.find_all do |entry|
            accepted = true

            @conditions.each do |_condition|
              unless _condition.matches?(entry)
                accepted = false
                break # no to go further
              end
            end
            accepted
          end
        end # filtered

        def self.key(name, operator)
          "#{name}.#{operator}"
        end

        def key(name, operator)
          self.class.key(name, operator)
        end

        alias :k :key

      end
    end
  end
end
