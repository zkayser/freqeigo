class WordListPresenter < ModelPresenter
  delegate :embedded_words, :paginate_words, :words, to: :object
  delegate :params, to: :view_context
  
  
  # Add header for Japanese words
  def word_header
    content_tag(:th, 'Words', class: "table-header")
  end
  
  # Add header for hiragana
  def hiragana_header
    content_tag(:th, 'Hiragana', class: "table-header")
  end
  
  # Add header for roman letter reading of Japanese words
  def reading_header
    content_tag(:th, 'Reading', class: "table-header")
  end
  
  # Add appropriate headers for English translations
  def translation_header
    content_tag(:th, 'Translations', class: "translation-head")
  end
  
  def table_row_for_word
    markup do |m|
      page = params[:page].to_i
      offset = page_offset(page)
      paginate_words(offset, 10).each do |word|
        first_row_for_word(m, word)
        if needs_extra_rows?(word)
          word.translations.each do |translation|
            extra_translation_rows(m, translation) unless translation == word.translations.first
          end
        end
      end
    end
  end
  
  private
  
  def first_row_for_word(markup, word)
    markup.tr do
      markup.td side_column_number
      markup.td word.word, class: 'word-list'
      markup.td word.hiragana, class: 'hiragana-list'
      markup.td word.reading, class: 'reading-list'
      markup.td first_translation(word), class: 'translation-list'
    end
  end
  
  # Get the number for the side column of the table
  def side_column_number
    @counter ||= 0
    if params[:page].to_i > 1
      number = (params[:page].to_i - 1) * 10
      @counter = number
    end
    @counter += 1
  end
  
  # Get the first translation printed out
  def first_translation(word)
    embedded_word.translations.first.translation
  end
  
  # Rows for the extra translations
  def extra_translation_rows(markup, translation)
    markup.tr do
      # Add 4 blank <td> because there are no word attributes
      4.times do
        markup.td
      end
      markup.td translation.translation, class: 'translation-list'
    end
  end
  
  def needs_extra_rows?(word)
    true if word.translations.length > 1
  end
  
  def page_offset(page)
    (page - 1) * 10
  end
end
