class ScheduleManager
  include Mongoid::Document
  include Schedulers::QuadraticCoefficientHandler
  include Cards::ScheduleTypeManager
  embedded_in :card
  field :reviewable, type: Mongoid::Boolean, default: true
  field :first_review?, type: Mongoid::Boolean, default: true
  field :latest_review_interval, type: Integer
  field :latest_review_bucket, type: Integer
  field :review_bucket, type: Integer
  field :next_due, type: DateTime, default: Time.now
  field :mastery_level, type: String
  field :master_stage, type: Integer
  field :stage, type: Integer
  field :schedule_type, type: String, default: "linear"
  field :quadratic_coefficient, type: Float
  field :review_strategy, type: String, default: "calculated"
  field :default_strategy, type: String, default: "calculated"
  field :strategy, type: Hash, default: {}
  validates :stage, numericality: { integer_only: 3 }, allow_nil: true
  validates :review_bucket, numericality: { less_than_or_equal_to: 5 }, allow_nil: true
  after_save :quadratic_setter
  
  private
    # This is not working right as a before_update. It resets the quadratic coefficient
    # to 2.0 no matter what. 
    def quadratic_setter
      self.quadratic_coefficient = set_quadratic_coefficient
      self.schedule_type = type_for(self.schedule_type)
    end
end
