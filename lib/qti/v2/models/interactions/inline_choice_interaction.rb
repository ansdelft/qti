module Qti
  module V2
    module Models
      module Interactions
        class InlineChoiceInteraction < BaseInteraction
          def self.matches(node, parent)
            match = node.at_xpath('.//xmlns:inlineChoiceInteraction') + node.at_xpath('.//xmlns:inlinechoiceinteraction')
            return false unless match.present?
            new(node, parent)
          end

          def shuffled?
            node.at_xpath('.//xmlns:inlineChoiceInteraction').attributes['shuffle']&.value&.downcase == 'true'
          end
        end
      end
    end
  end
end
