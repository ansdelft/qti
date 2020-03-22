module Qti
  module V2
    module Models
      module Interactions
        class SelectPointInteraction < BaseInteraction
          def self.matches(node, parent)
            matches = node.xpath('.//xmlns:selectPointInteraction')
            return false if matches.empty?

            new(matches.first, parent)
          end
        end
      end
    end
  end
end
