class ExampleSentencesController < ApplicationController
  def index
  end

  def create
    @example_sentence = ExampleSentence.new(sentence_params)
    @word = Word.find(params[:word])
    begin
      @example_sentences = params[:example_translations_attributes]
    rescue 
      puts "No example sentences passed in. Params: #{params}"
    end
    
    respond_to do |format|
      if @example_sentence.save
        @word.example_sentences << @example_sentence
        @word.save
        format.html { redirect_to @word, notice: "Example Sentence Added Successfully!" }
      else
        format.html { redirect_to @word, notice: "Failed to Add Sentence" }
      end
    end
  end
  
  def hiragana_convert
  end
    
  def convert
    @sentence = params[:sentence]
    @converted = HiraganaConverter.convert_hiragana(@sentence)
    respond_to do |format|
      format.js { render 'example_sentences/converted' }
    end
  end
  
  private 
  
  def sentence_params
    params.require(:example_sentence).permit(:sentence, :hiragana,
    :romaji, :language, :word,
    :example_translations_attributes => [:id, :example_translation])
  end
  
end
