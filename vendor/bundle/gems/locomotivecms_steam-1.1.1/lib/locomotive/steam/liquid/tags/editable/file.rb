module Locomotive
  module Steam
    module Liquid
      module Tags
        module Editable
          class File < Base

            def parse(tokens)
              super.tap do
                @path = [current_inherited_block_name, @slug].compact.join('--').gsub('/', '--')
              end
            end

            def render(context)
              apply_transformation(super, context)
            end

            protected

            def default_element_attributes
              super.merge({
                default_source_url: render_default_content.strip,
                resize_format:      @element_options[:resize]
              })
            end

            def render_element(context, element)
              url, timestamp = url_with_timestamp(context, element)
              context.registers[:services].asset_host.compute(url, timestamp)
            end

            def url_with_timestamp(context, element)
              default_timestamp = context.registers[:page].updated_at.to_i

              url, timestamp = (if element.source
                [source_url(element), default_timestamp]
              else
                if element.default_source_url.present?
                  [element.default_source_url, default_timestamp]
                else
                  [render_default_content, nil]
                end
              end)
            end

            def source_url(element)
              if element.source =~ /^https?/
                element.source
              else
                _url = element.source.start_with?('/') ? element.source : "/#{element.source}"
                "#{element.base_url}#{_url}"
              end
            end

            def apply_transformation(url, context)
              # resize image with the image_resizer service?
              if (format = @element_options[:resize]).present?
                url = context.registers[:services].image_resizer.resize(url, format) || url
              end

              # in the live editing mode, tag all the images with their editable path (block + slug)
              if editable?(context)
                url = url + (url.include?('?') ? '&' : '?') + 'editable-path=' + @path
              end

              url
            end

          end

          ::Liquid::Template.register_tag('editable_file'.freeze, File)
        end
      end
    end
  end
end
