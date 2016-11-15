class WordPresenter < ModelPresenter
  delegate :translations, :tags, to: :object
  delegate :params, :link_to, :word_path, :check_box_tag, :label_tag, :user_deck_create_path, to: :view_context
  
  
  # Header row for Japanese word lists
  def japanese_list_header
    markup do |m|
      m.th "#", class: "table-header"
      m.th "Kanji", class: "table-header", id: "toggle-word"
      m.th "Translations", class: "translation-head", id: "toggle-translations"
      m.th "Hiragana", class: "table-header", id: "toggle-hiragana"
      m.th "Romaji", class: "table-header", id: "toggle-reading"
      m.th "Synonyms", class: "table-header", id: "toggle-synonyms"
      m.th "Antonyms", class: "table-header", id: "toggle-antonyms"
    end
  end
  
  def table_row_for_word(word, index)
    markup do |m|
      first_row_for_word(m, word, index)
      translation_rows(m, word)
    end
  end
  
  def translation_rows(markup, word)
    if needs_extra_rows?(word)
      word.translations.each do |translation|
        unless translation == word.translations.first || translation == word.translations.last
          markup.tr do
            extra_translation_rows(markup, translation)
          end
        end
        last_translation_row(markup, translation) if translation == word.translations.last
      end
    end
  end
  
  # This method draws up the last table row with toggle buttons.
  def toggle_row
    markup do |m|
      rows = [ "word", "hiragana", "reading", "synonyms", "antonyms", "priority", "translations" ]
      m.tr do
        m.td ""
        rows.each do |row|
          m.td do
            m.button "Toggle", class: "btn btn-primary", id: "toggle-#{row}"
          end
        end
      end
    end
  end
  
  
  

  private
  
  # Outputs the first row with vocab and all applicable columns filled in.
  def first_row_for_word(markup, word, index)
    markup.tr class: 'vocab-row' do
      markup.td numbers(index)
      markup.td do
        markup.a word.word, class: 'word-list', href: word_path(word), "data-toggle" => "popover", "data-trigger" => "hover", "title" => "#{word.word}", "data-content" => "#{word.note}" 
      end
      markup.td first_translation(word), class: 'translation-list' unless word.translations.empty?
      markup.td word.hiragana, class: 'hiragana-list'
      markup.td word.reading, class: 'reading-list'
      if word.syns.any? # TEMPORARY SOLUTION 
        markup.td word.synonyms.first, class: 'synonym-list'
      else
        markup.td "", class: 'synonym-list'
      end
      if word.ants.any? # TEMPORARY SOLUTION
        markup.td word.antonyms.first, class: 'antonym-list'
      else
        markup.td "", class: 'antonym-list'
      end
    end
  end
  
  # Rows for the extra translations
  def extra_translation_rows(markup, translation)
      # Add 7 blank <td> because there are no word attributes
      2.times do
        markup.td
      end
      markup.td translation.translation, class: 'translation-list'
      4.times do
        markup.td
      end
  end
  
  # Pull out the last translation to mark it with a class name for identification.
  # This class will be used to manipulate the table with jquery
  def last_translation_row(markup, translation)
    markup.tr class: 'last-tr-row' do
      2.times do
        markup.td
      end
      markup.td translation.translation, class: 'translation-list'
      4.times do
        markup.td
      end
    end
  end
  
  
  # Calculates the left-hand column number on the table
  def numbers(index)
    if params[:page].to_i < 1
      start_number = 1
    else
      start_number = (params[:page].to_i * 10) - 9 # Gives the first number for the word on the page with 10 records per page (Page 2 * 10 - 9 => 11, etc.)
    end
    return start_number + index
  end
  
  # Get the first translation printed out
  def first_translation(word)
    word.translations.first.translation
  end
  
  def needs_extra_rows?(word)
    true if word.translations.length > 1
  end
end
