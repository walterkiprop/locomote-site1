module Locomotive
  module Steam
    module Liquid
      module Tags

        # Display the children pages of the site, current page or the parent page. If not precised, nav is applied on the current page.
        # The html output is based on the ul/li tags.
        #
        # Usage:
        #
        # {% nav site %} => <ul class="nav"><li class="on"><a href="/features">Features</a></li></ul>
        #
        # {% nav site, no_wrapper: true, exclude: 'contact|about', id: 'main-nav', class: 'nav', active_class: 'on' }
        #
        class Nav < ::Liquid::Tag

          Syntax = /(#{::Liquid::VariableSignature}+)/o

          attr_accessor :current_site, :current_page, :current_locale, :services, :page_repository

          def initialize(tag_name, markup, options)
            markup =~ Syntax

            @source = ($1 || 'page').gsub(/"|'/, '')

            self.set_options(markup, options)

            super
          end

          def render(context)
            self.set_vars_from_context(context)

            set_template_if_asked

            # get all the children of a source: site (index page), parent or page.
            pages   = children_of(fetch_starting_page)
            output  = self.build_entries_output(pages, context)

            if self.no_wrapper?
              output
            else
              self.render_tag(:nav, id: @_options[:id], css: @_options[:class]) do
                self.render_tag(:ul) { output }
              end
            end
          end

          protected

          # Build recursively the links of all the pages.
          #
          # @param [ Array ] pages List of pages
          #
          # @return [ String ] The final HTML output
          #
          def build_entries_output(pages, depth = 1, context)
            output  = []

            pages.each_with_index do |page, index|
              css = []
              css << 'first'  if index == 0
              css << 'last'   if index == pages.size - 1

              output << self.render_entry_link(page, css.join(' '), depth, context)
            end

            output.join("\n")
          end

          # Get the first page used to list all the children.
          # It depends on the source: site, parent, page or a fullpath
          #
          def fetch_starting_page
            case @source
            when 'site'    then page_repository.root
            when 'parent'  then page_repository.parent_of(current_page) || current_page
            when 'page'    then current_page
            else
              page_repository.by_fullpath(@source)
            end
          end

          # Get all the children of page. It filters the collection
          # to only return pages which will be displayed in the nav.
          def children_of(page)
            children  = (page_repository.children_of(page) || [])
            children.select { |child| self.include_page?(child) }
          end

          # Determine whether or not a page should be a part of the menu.
          #
          # @param [ Object ] page The page
          #
          # @return [ Boolean ] True if the page can be included or not
          #
          def include_page?(page)
            if !page.listed? || page.templatized? || !page.published?
              false
            elsif @_options[:exclude]
              (page.fullpath =~ @_options[:exclude]).nil?
            else
              true
            end
          end

          # Determine wether or not a page is currently the displayed one.
          #
          # @param [ Object ] page The page
          #
          # @return [ Boolean ]
          #
          def page_selected?(page)
            self.current_page.fullpath =~ /^#{page.fullpath}(\/.*)?$/
          end

          # Determine if the children of a page have to be rendered or not.
          # It depends on the depth passed in the option.
          #
          # @param [ Object ] page The page
          # @param [ Integer ] depth The current depth
          #
          # @return [ Boolean ] True if the children have to be rendered.
          #
          def render_children_for_page?(page, depth)
            depth.succ <= @_options[:depth].to_i && children_of(page).any?
          end

          # Return the label of an entry. It may use or not the template
          # given by the snippet option.
          #
          # @param [ Object ] page The page
          #
          # @return [ String ] The label in HTML
          #
          def entry_label(page, context)
            icon  = @_options[:icon] ? '<span></span>' : ''
            title = @_options[:liquid_render] ? @_options[:liquid_render].render({ 'page' => page }, registers: context.registers) : page.title

            if icon.blank?
              title
            elsif @_options[:icon] == 'after'
              "#{title} #{icon}"
            else
              "#{icon} #{title}"
            end
          end

          # Return the localized url of an entry (page).
          #
          # @param [ Object ] page The page
          #
          # @return [ String ] The localized url
          #
          def entry_url(page)
            services.url_builder.url_for(page)
          end

          # Return the css of an entry (page).
          #
          # @param [ Object ] page The page
          # @param [ String ] extra_css The extra css
          #
          # @return [ String ] The css
          #
          def entry_css(page, extra_css = '')
            ['link'].tap do |css|
              css << @_options[:active_class] if self.page_selected?(page)
              css << extra_css if !extra_css.blank?
            end.join ' '
          end

          # Return the HTML output of a page and its children if requested.
          #
          # @param [ Object ] page The page
          # @param [ String ] css The current css to apply to the entry
          # @param [ Integer] depth Used to know if the children has to be added or not.
          #
          # @return [ String ] The HTML output
          #
          def render_entry_link(page, css, depth, context)
            page      = decorate_page(page)
            url       = self.entry_url(page)
            label     = self.entry_label(page, context)
            css       = self.entry_css(page, css)
            options   = ''

            if self.render_children_for_page?(page, depth) && self.bootstrap?
              url       = '#'
              label     += %{ <b class="caret"></b>}
              css       += ' dropdown'
              options   = %{ class="dropdown-toggle" data-toggle="dropdown"}
            end

            self.render_tag(:li, id: "#{page.slug.to_s.dasherize}-link", css: css) do
              children_output = depth.succ <= @_options[:depth].to_i ? self.render_entry_children(page, depth.succ, context) : ''
              %{<a href="#{url}"#{options}>#{label}</a>} + children_output
            end
          end

          # Recursively create a nested unordered list for the depth specified.
          #
          # @param [ Array ] entries The children of the page
          # @param [ Integer ] depth The current depth
          #
          # @return [ String ] The HTML code
          #
          def render_entry_children(page, depth, context)
            entries = children_of(page)
            css     = self.bootstrap? ? 'dropdown-menu' : ''

            unless entries.empty?
              self.render_tag(:ul, id: "#{@_options[:id]}-#{page.slug.to_s.dasherize}", css: css) do
                self.build_entries_output(entries, depth, context)
              end
            else
              ''
            end
          end

          # Set the value (default or assigned by the tag) of the options.
          #
          def set_options(markup, options)
            @_options = { id: 'nav', class: '', active_class: 'on', bootstrap: false, no_wrapper: false }

            markup.scan(::Liquid::TagAttributes) { |key, value| @_options[key.to_sym] = value.gsub(/"|'/, '') }

            @_options[:exclude] = Regexp.new(@_options[:exclude]) if @_options[:exclude]
          end

          def set_template_if_asked
            if @_options[:snippet]
              if template = parse_snippet_template(@_options[:snippet])
                @_options[:liquid_render] = template
              end
            end
          end

          # Avoid to call context.registers to get the current page.
          #
          def set_vars_from_context(context)
            self.current_site       = context.registers[:site]
            self.current_page       = context.registers[:page]
            self.services           = context.registers[:services]
            self.current_locale     = context.registers[:locale]
            self.page_repository    = self.services.repositories.page
          end

          # Parse the template of the snippet give in option of the tag.
          # If the template_name contains a liquid tag or drop, it will
          # be used an inline template.
          #
          def parse_snippet_template(template_name)
            source = if template_name.include?('{{')
              template_name
            else
              snippet = services.snippet_finder.find(template_name)
              if snippet
                snippet.liquid_source
              else
                Locomotive::Common::Logger.warn "[Liquid][Nav] unable to find the #{template_name} snippet"
                nil
              end
            end

            source ? ::Liquid::Template.parse(source) : nil
          end

          # Render any kind HTML tags. The content of the tag comes from
          # the block.
          #
          # @param [ String ] tag_name Name of the HTML tag (li, ul, div, ...etc).
          # @param [ String ] html_options Id, class, ..etc
          #
          # @return [ String ] The HTML
          #
          def render_tag(tag_name, html_options = {}, &block)
            options = ['']
            options << %{id="#{html_options[:id]}"} if html_options[:id].present?
            options << %{class="#{html_options[:css]}"} if html_options[:css].present?

            %{<#{tag_name}#{options.join(' ')}>#{yield}</#{tag_name}>}
          end

          def decorate_page(page)
            klass = Locomotive::Steam::Decorators::I18nDecorator
            klass.new(page, current_locale, current_site.default_locale)
          end

          def bootstrap?
            @_options[:bootstrap].to_bool
          end

          def no_wrapper?
            @_options[:no_wrapper].to_bool
          end

          ::Liquid::Template.register_tag('nav'.freeze, Nav)
        end
      end
    end
  end
end
