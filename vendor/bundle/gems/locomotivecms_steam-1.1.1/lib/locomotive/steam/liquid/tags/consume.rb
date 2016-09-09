module Locomotive
  module Steam
    module Liquid
      module Tags

        # Consume web services as easy as pie directly in liquid!
        #
        # Usage:
        #
        # {% consume blog from 'http://nocoffee.tumblr.com/api/read.json?num=3' username: 'john', password: 'easy', format: 'json', expires_in: 3000 %}
        #   {% for post in blog.posts %}
        #     {{ post.title }}
        #   {% endfor %}
        # {% endconsume %}
        #
        class Consume < ::Liquid::Block

          Syntax = /(#{::Liquid::VariableSignature}+)\s*from\s*(#{::Liquid::QuotedString}|#{::Liquid::VariableSignature}+)(.*)?/o

          def initialize(tag_name, markup, options)
            if markup =~ Syntax
              @name = $1.to_s

              self.prepare_url($2)
              @default_api_options = parse_options_from_string($3)
            else
              raise ::Liquid::SyntaxError.new("Syntax Error in 'consume' - Valid syntax: consume <var> from \"<url>\" [username: value, password: value]")
            end

            super
          end

          def render(context)
            self.set_api_options(context)

            if instance_variable_defined?(:@variable_name)
              @url = context[@variable_name]
            end

            if @url.blank?
              Locomotive::Common::Logger.error "A consume tag can't call an empty URL."
              ''
            else
              render_all_and_cache_it(context)
            end
          end

          protected

          def prepare_url(token)
            if token.match(::Liquid::QuotedString)
              @url = token.gsub(/['"]/, '')
            else
              @variable_name = token
            end
          end

          def set_api_options(context)
            @api_options  = interpolate_options(@default_api_options, context)
            @expires_in   = @api_options.delete(:expires_in).try(:to_i)
          end

          def render_all_and_cache_it(context)
            cache_service(context).fetch(page_fragment_cache_key, cache_options) do
              self.render_all_without_cache(context)
            end
          end

          def render_all_without_cache(context)
            context.stack do
              begin
                Locomotive::Common::Logger.info "[consume] #{@url.inspect} / #{@api_options.inspect}"

                context.scopes.last[@name] = service(context).consume(@url, @api_options)
              rescue Timeout::Error
                context.scopes.last[@name] = last_response(context)
              end

              @body.render(context)
            end
          end

          def service(context)
            context.registers[:services].external_api
          end

          def cache_service(context)
            context.registers[:services].cache
          end

          def cache_options
            @expires_in.blank? ? { force: true } : { expires_in: @expires_in }
          end

          def last_response(context)
            cache_service(context).read(page_fragment_cache_key)
          end

          def page_fragment_cache_key
            "Steam-consume-#{Digest::SHA1.hexdigest(@name + @url)}"
          end

        end

        ::Liquid::Template.register_tag('consume'.freeze, Consume)
      end
    end
  end
end
