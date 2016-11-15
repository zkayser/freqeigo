class RecoveryManager
  include Mongoid::Document
  embedded_in :card
  field :til_recovery, type: Integer
  field :recoveries, type: Array
  field :in_recovery?, type: Mongoid::Boolean
  field :review_strategy, type: String, default: "calculated"
  field :default_strategy, type: String, default: "calculated"
end
