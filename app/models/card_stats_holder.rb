class CardStatsHolder
  include Mongoid::Document
  embedded_in :card
  field :cons_successful, type: Integer, default: 0
  field :failures, type: Integer, default: 0
  field :cons_failed, type: Integer, default: 0
  field :overall_correct, type: Integer, default: 0
  field :overall_seen, type: Integer, default: 0
  field :last_ten, type: Array, default: []
  validates :cons_successful, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
end
