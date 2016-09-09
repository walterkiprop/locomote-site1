module Locomotive::Steam
  module Middlewares

    # Set the timezone according to the settings of the site
    #
    class Timezone < ThreadSafe

      include Helpers

      def _call
        timezone = site.try(:timezone)

        log "Timezone: #{timezone.name}"

        Time.use_zone(timezone) do
          self.next
        end
      end

    end
  end
end
