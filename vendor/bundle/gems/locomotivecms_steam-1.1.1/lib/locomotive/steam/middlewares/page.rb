module Locomotive::Steam
  module Middlewares

    # Retrieve a page from the path and the locale previously
    # fetched from the request.
    #
    class Page < ThreadSafe

      include Helpers

      def _call
        return env['steam.page'] if env['steam.page']

        if page = fetch_page
          if !page.not_found?
            log "Found page \"#{page.title}\" [#{page.fullpath}]"
          else
            ActiveSupport::Notifications.instrument('steam.render.page_not_found', path: path, locale: locale, default_locale: default_locale)
            log "Page not found, rendering the 404 page.".magenta
          end
        end

        env['steam.page'] = page
      end

      protected

      def fetch_page
        services.page_finder.match(path).tap do |pages|
          if pages.size > 1
            self.log "Found multiple pages: #{pages.map(&:title).join(', ')}"
          end
        end.first || services.page_finder.find('404')
      end

    end

  end
end
