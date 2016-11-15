class Card
  include Mongoid::Document
  include Mongoid::Timestamps
  include Schedulers::QuadraticCoefficientHandler
  include Cards::ScheduleTypeManager
  embedded_in :deck
  embeds_one :stats, class_name: "CardStatsHolder", autobuild: true
  embeds_one :schedule_manager, autobuild: true
  embeds_one :recovery_manager, autobuild: true
  
  # Eliminate these delegate calls once the tests are passing.
  delegate :reviewable, :first_review?, :latest_review_interval, :latest_review_bucket, :review_bucket,
           :next_due, :mastery_level, :master_stage, :stage, :schedule_type, :quadratic_coefficient,
           :review_strategy, :default_strategy, to: :schedule_manager
  delegate :cons_successful, :failures, :cons_failed, :overall_correct, :overall_seen, :last_ten, to: :stats
  delegate :til_recovery, :recoveries, to: :recovery_manager

  field :top, type: String
  field :bottom, type: String
  field :question_type, type: String
  field :in_recovery?, type: Mongoid::Boolean

  
  scope :due, ->{ where('schedule_manager.reviewable' => true) }
  scope :future_due, ->{ where('schedule_manager.reviewable' => false) }
  validates :top, :bottom, presence: true
  
  
  def check_due
      self.schedule_manager.next_due < Time.now ? 
      self.schedule_manager.update_attribute(:reviewable, true) : 
      self.schedule_manager.update_attribute(:reviewable, false)
  end
  
  def reset
    self.schedule_manager.update_attributes!(
      reviewable: true,
      next_due: Time.now)
    self.stats.update_attribute(:cons_successful, 0)
  end
  
  def percent_correct
    ((stats.overall_correct.to_f / stats.overall_seen.to_f) * 100).round
  end
  
  # Updates the mastery_level
  def set_mastery_level
    if stats.overall_seen < 10
      mastery_level = Levels::LEVELS[0]
    elsif percent_correct < 25
      mastery_level = Levels::LEVELS[1]
    elsif percent_correct < 40 && percent_correct >= 25
      mastery_level = Levels::LEVELS[2]
    elsif percent_correct < 50 && percent_correct >= 40
      mastery_level = Levels::LEVELS[3]
    elsif percent_correct < 75 && percent_correct >= 50
      mastery_level = Levels::LEVELS[4]
    elsif percent_correct < 85 && percent_correct >= 75
      mastery_level = Levels::LEVELS[5]
    elsif percent_correct < 95 && percent_correct >= 85 && stats.overall_seen < 40
      mastery_level = Levels::LEVELS[6]
    elsif percent_correct <= 100 && percent_correct >= 95 && stats.overall_seen < 40
      mastery_level = Levels::LEVELS[7]
    elsif percent_correct < 95 && percent_correct >= 85 && stats.overall_seen >= 40
      mastery_level = Levels::LEVELS[8]
    elsif percent_correct <= 100 && percent_correct >= 95 && stats.overall_seen >= 40
      mastery_level = Levels::LEVELS[9]
    end
  end
  
  def increment_on_success
    self.stats.inc(cons_successful: 1)
    self.stats.inc(overall_correct: 1)
    self.stats.inc(overall_seen: 1)
    self.schedule_manager.update_attribute(:reviewable, false)
  end
  
  def increment_on_success_in_sandbox
    self.stats.inc(cons_successful: 1)
    self.stats.inc(overall_correct: 1)
    self.stats.inc(overall_seen: 1)
  end

  # OPTIMIZE => This can be made more concise and less reliant
  # on if/else conditions.
  def succeed(deck)
    deck.increment_on_success
    if in_recovery?
      scheduler = CardScheduler.new(self)
      scheduler.recovery_succeed
    else
      scheduler = CardScheduler.new(self)
      date = scheduler.calculate_next_review_date
      increment_on_success
      schedule_manager.update_attribute(:next_due, date)
      update_last_ten("pass")
      deck.num_cards_due
      if self.schedule_manager.first_review?
        self.schedule_manager.update_attribute(:first_review?, false)
      end
    end
    self.stats.save
    self.schedule_manager.save
  end
  
  # OPTIMIZE => Maybe it would be better here to make
  # a complete separate object to begin with called
  # SandboxCard or SandboxReview or something along those lines?
  def succeed_in_sandbox_mode(deck)
    deck.increment_on_success
    increment_on_success_in_sandbox
    deck.add_to_sandbox_passed_array(self.id)
  end
  
  def failed_in_sandbox_mode(deck)
    deck.increment_on_failure
    increment_on_failure_in_sandbox
  end
  
  def failed(deck)
    deck.increment_on_failure
    increment_on_failure
    update_last_ten("fail")
    self.stats.save
    self.schedule_manager.save
  end
  
  # OPTIMIZE => If you really think about it,
  # there should not be that big of a difference between
  # incrementing when failing and incrementing when succeeding.
  # If there is an object that responds to #increment and knows
  # what to do given the situation, either fail/succeed, it should
  # be able to increment the given values without all of this
  # direction on my part, making the increment calls more robust
  # and modular.
  def increment_on_failure
    self.stats.inc(failures: 1)
    self.stats.inc(overall_seen: 1)
    self.stats.inc(cons_failed: 1)
    self.stats.update_attribute(:cons_successful, 0)
    self.schedule_manager.update_attributes(
      reviewable: true,
      next_due: Time.now
    )
  end
  
  def increment_on_failure_in_sandbox
    self.stats.inc(failures: 1)
    self.stats.inc(overall_seen: 1)
    self.stats.inc(cons_failed: 1)
    self.stats.update_attribute(:cons_successful, 0)
  end
  
  # OPTIMIZE => Not really sure if we are even still going to use this 
  # now that you are relying on scheduler algorithms instead of paths, but
  # I will keep it here just in case for now (6/21). However, the 'last_ten'
  # field itself seems rather suspicious being on the card object only
  # for observation/configuration purposes. Maybe it should be moved to
  # a different module/class?
  def update_last_ten(pass_or_fail)
    self.stats.last_ten.shift
    self.stats.last_ten.push(pass_or_fail)
    self.save!
  end
  
  # OPTIMIZE => This whole before_create callback is very specific and may
  # cause trouble down the road for a number of reasons. However, 
    private
    def quadratic_setter
      self.schedule_manager.quadratic_coefficient = set_quadratic_coefficient
      self.schedule_manager.schedule_type = type_for(self.schedule_manager.schedule_type)
    end
end
