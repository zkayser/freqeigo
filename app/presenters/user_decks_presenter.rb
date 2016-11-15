class UserDecksPresenter < ModelPresenter
  delegate :current_user, :deck_link, :params, :link_to, :user_deck_path, :distance_of_time_in_words, :deck_path, :edit_deck_path, to: :view_context
  
  def table_header
    markup do |m|
      m.thead do
        m.th "Deck", class: "decks-header"
        m.th "Due", class: "decks-header"
        m.th "Total", class: "decks-header"
        m.th "Due Today", class: "decks-header"
        m.th "Next", class: "decks-header"
        m.th "Mastery", class: "decks-header"
        m.th "Overall", class: "decks-header"
      end
    end
  end
  
  def table_row_for_deck(user, deck)
      markup do |m|
        m.tr do
          m.td do
            m.a "Delete", href: deck_path(deck), "data-method" => "delete", class: "btn btn-sm btn-primary", "data-confirm" => "Are you sure?"
          end
          m.td do
            m.a "Edit", href: edit_deck_path(deck), class: "btn btn-sm btn-success"
          end
          m.td do
            m.a deck.title, href: user_deck_path(user, deck)
          end
          m.td deck.cards.length >= 1 ? deck.current_due.length : "0"
          m.td deck.cards.length > 0 ? deck.cards.length : "0"
          unless deck.current_due.length == deck.due_today
            m.td deck.due_today >= 1 ? deck.due_today : "0"
          else
            m.td ""
          end
          if deck.cards.any? && !deck.current_due.any? # If there are no cards due, show the date for the next review.
            next_due = []
            deck.cards.each do |card|
              next_due << card.next_due
            end
            m.td distance_of_time_in_words(next_due.min, Time.now).titleize
          else
            m.td ""
          end
          m.td "Rookie" # TO DO: Later, devise a method that ranks decks from Rookie to Master based on # of reviews & percent correct
          m.td deck.overall_correct_percent.to_s + "%"
        end
      end
  end
end