class Plan
  include Mongoid::Document
  field :name, type: String
  field :amount, type: Float
  field :interval, type: String
  field :trial_period_days, type: String
  field :created, type: DateTime
  field :currency, type: String
  field :_id, type: String
  field :object, type: String
end
