module Locomotive
  module Wagon
    module Generators
      module Site

        class Blank < Base

          may_use_haml

          def choose_haml_over_html
            if haml?
              remove_file File.join(self.destination, 'app/views/pages/index.liquid')
              remove_file File.join(self.destination, 'app/views/pages/404.liquid')
            else
              remove_file File.join(self.destination, 'app/views/pages/index.liquid.haml')
              remove_file File.join(self.destination, 'app/views/pages/404.liquid.haml')
            end
          end

          def bundle_install
            super
          end

        end

        Locomotive::Wagon::Generators::Site.register(:blank, Blank, %{
          A blank site with the minimal files.
        })
      end
    end
  end
end