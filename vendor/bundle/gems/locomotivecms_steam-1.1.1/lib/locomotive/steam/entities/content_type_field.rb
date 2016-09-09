module Locomotive::Steam

  class ContentTypeField

    include Locomotive::Steam::Models::Entity

    attr_accessor :content_type

    def initialize(attributes = {})
      super({
        type:       :string,
        localized:  false,
        required:   false,
        unique:     false,
        default:    nil
      }.merge(attributes))
    end

    def type
      self[:type].try(:to_sym)
    end

    def class_name
      self[:class_name] || self[:target]
    end

    def order_by
      if (order_by = self[:order_by]).present?
        # from Filesystem -> string, from MongoDB -> array (string transformed by Engine)
        name, direction = order_by.respond_to?(:each) ? order_by : order_by.split
        { name.to_sym => direction || 'asc' }
      else
        type == :has_many ? { :"position_in_#{self[:inverse_of]}" => 'asc' } : nil
      end
    end

    alias :target :class_name

    def target_id
      return @target_id if @target_id

      @target_id = if self.target =~ Locomotive::Steam::CONTENT_ENTRY_ENGINE_CLASS_NAME
        $1
      else
        self.target
      end
    end

    def required?; self[:required]; end
    def localized?; self[:localized]; end

    def association_options
      {
        target_id:  target_id,
        inverse_of: self[:inverse_of],
        order_by:   order_by
      }
    end

    def is_relationship?
      %i(belongs_to has_many many_to_many).include?(self.type)
    end

    def persisted_name
      case type
      when :belongs_to, :select then "#{name}_id"
      when :many_to_many        then "#{name.singularize}_ids"
      when :has_many            then nil
      else name
      end
    end

    class SelectOption

      include Locomotive::Steam::Models::Entity

      attr_accessor :field

      def name
        self[:name]
      end

    end

  end
end
