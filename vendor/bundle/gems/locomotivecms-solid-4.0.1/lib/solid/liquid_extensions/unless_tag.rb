module Solid
  module LiquidExtensions
    class UnlessTag < Solid::LiquidExtensions::IfTag

      tag_name :unless

      def initialize(tag_name, expression, options)
        super(tag_name, "!(#{expression})", options)
      end

    end
  end
end
