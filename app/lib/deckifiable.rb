module Deckifiable
  
  def self.included(base)
    base.extend ClassMethods
  end
  
  def deckify(user)
    # Deckify only works with WordList and Word object at this point.
    # You need a more generalized method to handle different objects.
    # Note that self as I use it here points to a WordList object.
    deck = Deck.new(user: user, title: self.title, from_word_list: self.title)
    words = self.words.all.to_a
    words.each do |word|
      word.cardify(deck)
    end
    user.save
  end
  
  def deckify_word_example_sentences(user, word)
    deck = Deck.new(user: user, title: word.word + " examples")
    example_sentences = word.example_sentences.all.to_a
    example_sentences.each do |ex|
      ex.cardify(deck)
    end
    user.save
  end
  
  def deckify_with_options(user, *matches, title)
    deck = Deck.new(user: user, title: title, from_word_list: self.title)
    words = self.words.all.to_a
    words.each do |word|
      word.cardify_with_options(deck, matches)
    end
    user.save
  end
end

