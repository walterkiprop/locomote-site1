module Locomotive::Steam

  class ContentType

    include Locomotive::Steam::Models::Entity
    extend Forwardable

    def_delegator :fields, :associations, :association_fields
    def_delegator :fields, :selects, :select_fields
    def_delegator :fields, :files, :file_fields
    def_delegator :fields, :default, :fields_with_default

    def initialize(attributes = {})
      super({
        order_by:         '_position',
        order_direction:  'asc'
      }.merge(attributes))
    end

    def fields
      # Note: this returns an instance of the ContentTypeFieldRepository class
      self.entries_custom_fields
    end

    def fields_by_name
      @fields_by_name ||= (fields.all.inject({}) do |memo, field|
        memo[field.name] = field
        memo
      end).with_indifferent_access
    end

    def localized_names
      fields.localized_names + select_fields.map(&:name)
    end

    def persisted_field_names
      [].tap do |names|
        fields_by_name.each do |name, field|
          _name = field.persisted_name
          names << _name if _name
        end
      end
    end

    def label_field_name
      (self[:label_field_name] || fields.first.name).to_sym
    end

    def order_by
      name = self[:order_by] == 'manually' ? '_position' : self[:order_by]

      # check if name is an id of field
      if field = fields.find(name)
        name = field.name
      end

      { name.to_sym => self.order_direction.to_s }
    end

  end
end
