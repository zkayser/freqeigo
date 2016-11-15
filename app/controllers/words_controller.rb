class WordsController < ApplicationController
  before_action :set_word, only: [:show, :edit, :update, :destroy]
  before_action :check_admin_status, except: [:index, :show]

  # GET /words
  # GET /words.json
  def index
    @words = Word.all.page params[:page]
    
    respond_to do |format|
      format.html
      format.js { }
      format.json { render json: WordsHelper::WordsDataTable.new(view_context) }
    end
  end
  
  def vocab_list
     @words = Word.all.page params[:page]
    
    respond_to do |format|
      format.html { render 'words/index' }
      format.js { }
    end
  end

  # GET /word/1
  # GET /word/1.json
  def show
    @word = Word.find(params[:id])
    @example_sentence = @word.example_sentences.new
  end

  # GET /words/new
  def new
    @word = Word.new
  end

  # GET /words/1/edit
  def edit
    @word = Word.find(params[:id])
  end

  # POST /words
  # POST /words.json
  def create
    @word = Word.new(word_params)

    respond_to do |format|
      if @word.save
        format.html { redirect_to @word }
        format.json { render :show, status: :created, location: @word }
      else
        format.html { render :new }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /word_lists/1
  # PATCH/PUT /word_lists/1.json
  def update

    respond_to do |format|
      if @word.update(word_params)
        format.html { redirect_to @word }
        format.json { render :show, status: :ok, location: @word }
      else
        format.html { render :edit }
        format.json { render json: @word.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_lists/1
  # DELETE /word_lists/1.json
  def destroy
    @word.destroy
    respond_to do |format|
      format.html { redirect_to vocab_list_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word
      @word = Word.find(params[:id])
    end
    
    # Check admin status. If user is not an admin, redirect to home page
    def check_admin_status
      if current_user.nil? || !current_user.admin?
        flash[:alert] = "Access denied. Please login as an admin user"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_params
      params.require(:word).permit(:word, :hiragana, 
        :reading, :part_of_speech, :word_list_id,
        :note, :synonyms, :antonyms, :priority,
        :translations_attributes => [:id, :translation, 
                                     :language, :_destroy],
        :tag_attributes => [:id, :tag],
        :syn_attributes => [:id, :synonym],
        :ant_attributes => [:id, :antonym],)
    end
    
end
