module Qti
  module V2
    module Models
      module Interactions
        class UploadInteraction < BaseInteraction
          def self.matches(node, parent)
            matches = node.xpath('.//xmlns:uploadInteraction')
            return false if matches.empty?

            new(matches.first, parent)
          end
        end
      end
    end
  end
end
