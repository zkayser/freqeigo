module DecksHelper
  def deck_link
    content_for(:deck_link).html_safe || "No link"
  end
  
  def next_due(deck)
    if deck.cards.any? && !deck.current_due.any?
      next_due = []
      deck.cards.each do |card|
        next_due.push (card.next_due)
      end
    end
  end
  
  # Returns the total amount of cards due from all decks
  # in a group -> for use in views displaying multiple decks
  def total_due_for_group(decks)
    due = 0
    decks.each do |deck|
      if deck.cards_due?
        due += deck.cards.due.length
      end
    end
    return due
  end
  
  # Returns the total amount of cards due within 24 hours
  # in a group, for use in views displaying multiple decks
  def total_due_today_for_group(decks)
    due = 0
    decks.each do |deck|
      due += deck.due_today
    end
    return due
  end
  
  # Return total amount of cards overall for a group of decks
  def total_number_of_cards_in(decks)
    cards = 0
    decks.each do |deck|
      cards += deck.cards.length
    end
    return cards
  end
end
