module Cardifiable
  
  # This should probably be handled in the including classes.
  # The Cardifiable module itself should not have to know anything about the
  # classes it is being included in.
  CARDIFIABLE_FIELDS = %w(word hiragana reading synonyms antonyms translations sentence romaji example_translations)
  
  def cardify(deck)
    self.defaults.each do |default_array|
      unless blank(self, default_array) || top_bottom_equal(self, default_array)
        top = set_tops(deck, self, default_array)
        set_bottoms(deck, self, top, default_array)
      end
    end
  end
  
  
  def cardify_with_options(deck, *pairings)
    pairings.flatten(2).each do |pair_array|
      unless blank(self, pair_array) || top_bottom_equal(self, pair_array)
        top = set_tops(deck, self, pair_array)
        set_bottoms(deck, self, top, pair_array)
      end
    end
  end
        
    
  def reverse_card(card)
    new_card = Card.new(deck: card.deck)
    new_card.top = card.bottom
    new_card.bottom = card.top
    new_card.question_type = card.question_type
    new_card.save!
    deck.save!
  end
  
  # Call this method on objects which include the Cardifiable module to 
  # make a standard card out of the object.
  def to_card(deck)
    self.cardify(deck)
  end
  
  private
  
    def blank(word, attr_array)
      word.send(attr_array[0]).blank? || word.send(attr_array[1]).blank?
    end
  
    def top_bottom_equal(word, attr_array)
      word.send(attr_array[0]) == word.send(attr_array[1])
    end
    
    def set_tops(deck, object, attr_array)
      unless object.send(attr_array[0]).respond_to?(:each)
        top = object.send(attr_array[0])
      else
        top = []
        object.send(attr_array[0]).each do |attr|
          singular = attr_array[0].to_s.singularize
          top << attr.send(singular)
        end
        top = top.join("<br/><br/>")
      end
      return top
    end
    
    def set_bottoms(deck, object, top, attr_array)
      unless object.send(attr_array[1]).respond_to?(:each)
        bottom = object.send(attr_array[1])
        card = Card.new(deck: deck, top: top, bottom: bottom, question_type: attr_array[1].to_s)
      else
        bottom = []
        object.send(attr_array[1]).each do |attr|
          singular = attr_array[1].to_s.singularize
          bottom << attr.send(singular)
        end
        bott = bottom.join("<br/><br/>")
        card = Card.new(deck: deck, top: top, bottom: bott, question_type: attr_array[1].to_s)
      end
      save_deck(deck, card)
    end
    
    def save_deck(deck, card)
      card.save!
      deck.save!
    end
end