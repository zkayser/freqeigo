# This class may demonstrate weird behavior on calls of the form #add_xxx_days_and_yyy_hours
# or similar due to calling method missing.
class CardScheduler
  DEFAULT_CLASS = Schedulers::Scheduler
  SPECIALIZED_CLASSES = {
    'exponential' => Schedulers::Exponential,
    'quadratic' => Schedulers::Quadratic
  }
  
  attr_accessor :card, :scheduler
  
  def initialize(card)
    @card = card
    @scheduler = klass_for(@card.schedule_manager.schedule_type).new(@card)
  end
  
  # Recovery strategies will take over in special cases.
  # In the Deck model, these strategies should be available to users creating
  # decks. Users should also have the option to turn off RECOVERY STRATEGIES
  # and ignore them completely. When a card is in recovery_mode, reviews will
  # take place under special conditions where the failures and last_ten
  # attributes will be ignored.
  REVIEW_STRATEGIES = %w(calculated normal persistent berserk steady acquainted master_review)
  RECOVERY_STRATEGIES = %w(triple_failure_recovery five_of_ten_recovery ten_or_more_recovery)
  STR_NO_TO_INT = {
    "one": 1,
    "two": 2,
    "three": 3,
    "four": 4,
    "five": 5,
    "six": 6,
    "seven": 7,
    "eight": 8,
    "nine": 9,
    "ten": 10,
    "eleven": 11,
    "twelve": 12,
    "thirteen": 13,
    "fourteen": 14,
    "fifteen": 15,
    "sixteen": 16,
    "seventeen": 17,
    "eighteen": 18,
    "nineteen": 19,
    "twenty": 20,
    "twenty_one": 21,
    "twenty_two": 22,
    "twenty_three": 23,
    "twenty_four": 24,
    "twenty_five": 25,
    "twenty_six": 26,
    "twenty_seven": 27,
    "twenty_eight": 28,
    "twenty_nine": 29,
    "thirty": 30,
    "thirty_one": 31
  }
  
  # OPTIMIZE
  
  # 6/16 -> What I actually want is for this object to have
  # a public facing method called #schedule_card
  def calculate_next_review_date
    if @card.failures <= 0
      interval_shortener = 1
    elsif @card.failures >= 1 && @card.failures < 10
      # Shorten the interval for every failure
      interval_shortener = 1 - ( @card.failures / 10 )
    else
      interval_shortener = 0.1
    end
    interval_multiplier = 8 * ((2 ** @card.cons_successful) * interval_shortener)
    @card.schedule_manager.next_due = Time.now + interval_multiplier.hours
  end
  
  # 6/16 -> What I actually want is for this object to have
  # a public facing method called #schedule_card called on passing cards
  def klass_for(schedule_type)
    (SPECIALIZED_CLASSES[schedule_type] || DEFAULT_CLASS)
  end
  
  def advance
    @scheduler.advance
  end
  
  def update_scheduler_type
    @scheduler = klass_for(@card.schedule_manager.schedule_type).new(@card)
  end
  
  # REFACTOR!! This method does too much!
  def triple_failure_recovery_success
    if @card.til_recovery >= 1
       @card.update_attributes(
        next_due: Time.now + 4.hours,
        til_recovery: @card.til_recovery - 1
        )
    else
      @card.update_attributes(
        next_due: Time.now + 8.hours,
        cons_failed: 0,
        review_stategy: @card.default_strategy,
        in_recovery?: false
        )
    end
  end
  
  # REFACTOR!!
  def set_recovery_strategy
    if @card.stats.cons_failed >= 3
      @card.recovery_manager.update_attributes!(
        review_strategy: "triple_failure_recovery",
        til_recovery: 3,
        in_recovery?: true
        )
    elsif self.last_ten_percentage && self.last_ten_percentage >= 50
      @card.recovery_manager.update_attributes!(
        review_strategy: "five_of_ten_recovery",
        til_recovery: 6,
        in_recovery?: true
        )
    elsif @card.stats.failures >= 10 && @card.percent_correct < 80
      @card.recovery_manager.update_attributes!(
        review_strategy: "ten_or_more_recovery",
        til_recovery: 10,
        in_recovery?: true
        )
    end
  end
  
  # Has nothing to do with scheduling a card. Should be removed.
  def last_ten_percentage
    fail_count = @card.last_ten.count("fail")
    unless @card.last_ten.include?(nil)
      ((fail_count.to_f / 10.0) * 100).round
    end
  end
  
  def reset
    @card.schedule_manager.update_attribute(:next_due, Time.now)
  end
  
  def times_per_time_period(times, time_period)
    number = time_period_to_numeric(time_period)
    due_date = (number.to_f / times.to_f)
    period_type = get_time_period_type(time_period)
    due_date = due_date.to_i if period_type == "months" # .months cannot be called on Float objects
    @card.schedule_manager.update_attribute(:next_due, Time.now + due_date.send("#{period_type.to_sym}"))
  end
  
  def get_time_period_type(time_period_type)
    case time_period_type
      when "year"
        "months"
      when "month"
        "days"
      when "day"
        "hours"
      when "hour"
        "minutes"
      else 
        raise Cards::InvalidTimeError.new
    end
  end
  
  def time_period_to_numeric(time_period)
    case time_period
    when "year"
      12
    when "month"
      30
    when "day"
      24
    when "hour"
      60
    else
      raise Cards::InvalidTimeError.new
    end
  end
    
  # Catches calls to methods of the form add_xx_days/add_xx_hours
  # or add_xx_days_and_yy_hour(s) and sets the scheduler's card's next
  # due attribute to the time with the specified times added. 
  def method_missing(method, *args, &block)
    if method.to_s =~ /add_(.*)_day_and_(.*)_hour/ || method.to_s =~ /add_(.*)_days_and_(.*)_hour/
      if $1.in?(STR_NO_TO_INT.stringify_keys.keys) && $2.in?(STR_NO_TO_INT.stringify_keys.keys)
        day_incrementer = STR_NO_TO_INT[$1.to_sym]
        hour_incrementer = STR_NO_TO_INT[$2.to_sym]
        @card.schedule_manager.update_attribute(:next_due, Time.now + day_incrementer.days + hour_incrementer.hours)
      else
        puts "#{$1} and/or #{$2} could not be converted to an integer"
      end
    elsif method.to_s =~ /add_(.*)_day/
      if $1.in?(STR_NO_TO_INT.stringify_keys.keys)
        day_incrementer = STR_NO_TO_INT[$1.to_sym]
        @card.schedule_manager.update_attribute(:next_due, Time.now + day_incrementer.days)
      else
        puts "#{$1} could not be converted to an integer"
      end
    elsif method.to_s =~ /add_(.*)_hour/
      if $1.in?(STR_NO_TO_INT.stringify_keys.keys)
        hour_incrementer = STR_NO_TO_INT[$1.to_sym]
        @card.schedule_manager.update_attribute(:next_due, Time.now + hour_incrementer.hours)
      else
        puts "#{$1} could not be converted to an integer"
      end
    elsif method.to_s =~ /(.*)_per_(.*)/
      if $1.in?(STR_NO_TO_INT.stringify_keys.keys)
        times = STR_NO_TO_INT[$1.to_sym]
        time_period = $2
        times_per_time_period(times, time_period)
      else
        puts "#times_per_time_period called with arguments: #{$1}, #{$2}"
      end
    else
      super
    end
  end
end