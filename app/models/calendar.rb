class Calendar
  include Mongoid::Document
  embedded_in :user
  
  def reviews_due_today
    due_count = 0
    user.decks.each do |d|
      due_count += d.due_count unless d.due_count.nil?
    end
    return due_count
  end
end
