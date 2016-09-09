require 'chronic'

module Locomotive::Steam

  class ContentEntry

    include Locomotive::Steam::Models::Entity

    attr_accessor :content_type

    def initialize(attributes = {})
      super({
        _visible:     true,
        _position:    0,
        created_at:   Time.zone.now,
        updated_at:   Time.zone.now
      }.merge(attributes))
    end

    def _id; self[:_id] || self[:id]; end

    def _visible?; !!self[:_visible]; end
    alias :visible? :_visible?

    def _slug; self[:_slug]; end
    alias :_permalink :_slug

    def method_missing(name, *args, &block)
      if is_dynamic_attribute?(name)
        cast_value(name)
      elsif attributes.include?(name)
        self[name]
      else
        super
      end
    end

    def valid?
      errors.clear
      content_type.fields.required.each do |field|
        errors.add_on_blank(field.name.to_sym)
      end
      errors.empty?
    end

    def content_type
      @content_type || attributes[:content_type]
    end

    def content_type_id
      @content_type.try(&:_id) || attributes[:content_type_id]
    end

    def content_type_slug
      content_type.slug
    end

    def _class_name
      "Locomotive::ContentEntry#{content_type_id}"
    end

    def _label
      self[content_type.label_field_name]
    end

    def localized_attributes
      @localized_attributes.tap do |hash|
        if hash && hash.has_key?(content_type.label_field_name.to_sym)
          hash[:_label] = true
        end
      end
    end

    def serialize
      super.merge(content_type_id: content_type_id)
    end

    def to_hash
      # default attributes
      _attributes = %i(_id _slug _label _visible _position content_type_slug created_at updated_at)

      # dynamic attributes
      _attributes += content_type.persisted_field_names

      _attributes.inject({}) do |hash, name|
        hash[name.to_s] = send(name)
        hash
      end.tap do |hash|
        # errors?
        hash['errors'] = self.errors.to_hash.stringify_keys unless self.errors.empty?
      end
    end

    def to_liquid
      Locomotive::Steam::Liquid::Drops::ContentEntry.new(self)
    end

    private

    def is_dynamic_attribute?(name)
      content_type.fields_by_name.has_key?(name)
    end

    def cast_value(name)
      field = content_type.fields_by_name[name]

      begin
        _cast_value(field)
      rescue Exception => e
        Locomotive::Common::Logger.info "[#{content_type.slug}][#{_label}] Unable to cast the \"#{name}\" field, reason: #{e.message}".yellow
        nil
      end
    end

    def _cast_value(field)
      if private_methods.include?(:"_cast_#{field.type}")
        send(:"_cast_#{field.type}", field)
      else
        attributes[field.name]
      end
    end

    def _cast_integer(field)
      _cast_convertor(field.name, &:to_i)
    end

    def _cast_float(field)
      _cast_convertor(field.name, &:to_f)
    end

    def _cast_file(field)
      _cast_convertor(field.name) do |value, locale|
        if value.respond_to?(:url)
          value
        else
          size = (self[:"#{field.name}_size"] || {})[locale || 'default']
          FileField.new(value, self.base_url, size, self.updated_at)
        end
      end
    end

    def _cast_date(field)
      _cast_time(field, :to_date)
    end

    def _cast_date_time(field)
      _cast_time(field, :to_datetime)
    end

    def _cast_time(field, end_method)
      _cast_convertor(field.name) do |value|
        if value.is_a?(String)
          # context: time from a YAML file (String).
          # In that case, use the timezone defined by the site.
          Chronic.time_class = Time.zone
          Chronic.parse(value).send(end_method)
        else
          value
        end
      end
    end

    def _cast_select(field)
      _cast_convertor(:"#{field.name}_id") do |value|
        field.select_options.find(value).try(:name)
      end
    end

    def _cast_convertor(name, &block)
      if (value = attributes[name]).respond_to?(:translations)
        value.apply(&block)
      else
        yield(value)
      end
    end

    # Represent a file
    class FileField

      attr_accessor_initialize :filename, :base, :size, :updated_at

      def url
        return if filename.blank?
        base.blank? ? filename : "#{base}/#{filename}"
      end

      def to_json
        url
      end

      def to_liquid
        Locomotive::Steam::Liquid::Drops::UploadedFile.new(self)
      end

    end

  end

end
