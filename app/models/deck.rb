class Deck
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  embeds_many :cards
  belongs_to :user
  has_one :category
  has_one :subcategory
  paginates_per 10
  field :title, type: String
  field :from_word_list, type: String
  field :current_correct, type: Integer, default: 0
  field :current_seen, type: Integer, default: 0
  field :last_current_update, type: DateTime, default: Time.now # Used to update current deck stats every 2 hours.
  field :due_count, type: Integer
  field :total_correct, type: Integer, default: 0
  field :total_seen, type: Integer, default: 0
  field :master_level, type: String, default: "Rookie"
  field :sandbox_passed, type: Array, default: []
  field :sandbox_due, type: Array, default: []
  

  
  # Find if a given deck has any cards due
  def cards_due?
    if self.cards.due.any?
      return true
    end
  end
  
  # Calculate the number of due cards outstanding
  def num_cards_due
    if cards_due?
      self.due_count = self.cards.due.length
    else
      0
    end
  end
  
  # Calculate the percentage of questions answered correctly for the given
  # round
  def current_correct_percent
    if current_seen > 0
      ((current_correct.to_f/current_seen.to_f) * 100).round
    end
  end
  
  # Calculate the overall percentage of questions answered correctly
  # for the given deck
  def overall_correct_percent
    if total_seen > 0
      ((total_correct.to_f/total_seen.to_f) * 100).round
    else
      0
    end
  end
  
  # Find the total correct overall vs the number of cards seen as
  # integers
  def update_total_correct
    correct = 0
    self.cards.each do |card|
      correct += card.stats.overall_correct
    end
    return correct
  end
  
  def update_total_seen
    seen = 0
    self.cards.each do |card|
      seen += card.stats.overall_seen
    end
    return seen
  end
  
  # Use this method to make sure that 
  # due cards are being kept current
  # between requests, whether they are Ajax
  # or regular requests
  def current_due
    self.cards.due.to_a.each do |card|
      card.check_due
    end
  end
  
  def current_sandbox_due_length
    self.cards.all.to_a.each do |card|
      self.sandbox_due << card.id unless card.id.in?(self.sandbox_passed)
    end
    self.sandbox_due.length
  end
  
  def reset_cards
    self.cards.to_a.each do |card|
      card.reset
    end
  end
  
  # Resets the failure attribute to zero
  def failure_reset
    self.cards.to_a.each do |card|
      card.stats.failures = 0
      card.save!
    end
  end
  
  # Resets current_correct and current_seen deck stats to zero after 2 hours
  def reset_current_stats
    if last_current_update < 2.hours.ago
      self.current_seen = 0
      self.current_correct = 0
      self.last_current_update = Time.now
      self.due_count = self.cards.due.length
    end
    self.save
  end
  
  # Checks the number of cards due within 24 hours
  def due_today
    due_today = []
    self.cards.each do |card|
      if card.schedule_manager.next_due < (Time.now + 1.day)
        due_today << card
      end
    end
    due_today.length
  end
  
  # Checks the datetime for the next card
  def next_due
    if self.cards.future_due.any?
      due = self.cards.future_due.first.next_due
      self.cards.future_due.each do |card|
        due_date = card.schedule_manager.next_due < due ? card.schedule_manager.next_due : due
        due = due_date
      end
    else
      due = ""
    end
    return due
  end
  
  def set_mastery_level
    if total_seen < (self.cards.length * 5) || total_seen == 0
      mastery_level = Levels::LEVELS[0]
    elsif overall_correct_percent < 25
      mastery_level = Levels::LEVELS[1]
    elsif overall_correct_percent < 40 && overall_correct_percent >= 25
      mastery_level = Levels::LEVELS[2]
    elsif overall_correct_percent < 50 && overall_correct_percent >= 40
      mastery_level = Levels::LEVELS[3]
    elsif overall_correct_percent < 75 && overall_correct_percent >= 50
      mastery_level = Levels::LEVELS[4]
    elsif overall_correct_percent < 85 && overall_correct_percent >= 75
      mastery_level = Levels::LEVELS[5]
    elsif overall_correct_percent < 95 && overall_correct_percent >= 85 && total_seen < (self.cards.length * 20)
      mastery_level = Levels::LEVELS[6]
    elsif overall_correct_percent <= 100 && overall_correct_percent >= 95 && total_seen < (self.cards.length * 20)
      mastery_level = Levels::LEVELS[7]
    elsif overall_correct_percent < 95 && overall_correct_percent >= 85 && total_seen >= (self.cards.length * 20)
      mastery_level = Levels::LEVELS[8]
    elsif overall_correct_percent <= 100 && overall_correct_percent >= 95 && total_seen >= (self.cards.length * 20)
      mastery_level = Levels::LEVELS[9]
    end
  end
  
  def increment_on_success
    self.inc(current_seen: 1)
    self.inc(current_correct: 1)
    self.inc(total_seen: 1)
    self.inc(total_correct: 1)
    self.update_attribute(:last_current_update, Time.now)
  end
  
  def increment_on_failure
    self.inc(current_seen: 1)
    self.inc(total_seen: 1)
    self.update_attribute(:last_current_update, Time.now)
  end
  
  def add_to_sandbox_passed_array(card_id)
    self.sandbox_passed << card_id
    begin
      self.save!
      rescue => e
        self.cards.each do |c|
          unless c.valid?
            puts "Destroying card: #{c.id}"
            c.destroy!
          end
        end
        puts e.message
        puts e.backtrace
    end
  end
end
