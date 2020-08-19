require 'forwardable'
require_relative 'match_item_tag_processors/match_interaction_tag_processor'
require_relative 'match_item_tag_processors/associate_interaction_tag_processor'

module Qti
  module V2
    module Models
      module Interactions
        class MatchInteraction < BaseInteraction
          extend Forwardable

          attr_reader :implementation

          def initialize(node, parent, implementation)
            super(node, parent)
            @implementation = implementation.new(node, parent)
          end

          def_delegators :@implementation, :answers, :questions, :shuffled?

          def scoring_data_structs
            implementation.scoring_data_structs
          end

          def self.matches(node, parent)
            implementation =
              if use_associate_interaction_implementation?(node)
                MatchItemTagProcessors::AssociateInteractionTagProcessor
              elsif use_match_interaction_implementation?(node)
                MatchItemTagProcessors::MatchInteractionTagProcessor
              end

            return false unless implementation.present?
            new(node, parent, implementation)
          end

          def self.use_associate_interaction_implementation?(node)
            MatchItemTagProcessors::AssociateInteractionTagProcessor.associate_interaction_tag?(node) &&
              MatchItemTagProcessors::AssociateInteractionTagProcessor.number_of_questions_per_answer(node)
                                                                      .all? { |n| n == 1 }
          end

          def self.use_match_interaction_implementation?(node)
            MatchItemTagProcessors::MatchInteractionTagProcessor.match_interaction_tag?(node) &&
              MatchItemTagProcessors::MatchInteractionTagProcessor.number_of_questions_per_answer(node)
                                                                  .all? { |n| n == 1 }
          end
        end
      end
    end
  end
end
