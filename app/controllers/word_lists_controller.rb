class WordListsController < ApplicationController
  include Cardifiable
  before_action :set_word_list, only: [:show, :edit, :update, :destroy]
  before_action :check_admin_status

  # GET /word_lists
  # GET /word_lists.json
  def index
    @word_lists = WordList.all
  end

  # GET /word_lists/1
  # GET /word_lists/1.json
  def show
    @words = @word_list.words.limit
  end

  # GET /word_lists/new
  def new
    @word_list = WordList.new
  end

  # GET /word_lists/1/edit
  def edit
  end

  # POST /word_lists
  # POST /word_lists.json
  def create
    @word_list = WordList.new(word_list_params)

    respond_to do |format|
      if @word_list.save
        format.html { redirect_to @word_list, notice: 'Word list was successfully created.' }
        format.json { render :show, status: :created, location: @word_list }
      else
        format.html { render :new }
        format.json { render json: @word_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /word_lists/1
  # PATCH/PUT /word_lists/1.json
  def update

    respond_to do |format|
      if @word_list.update(word_list_params)
        format.html { redirect_to @word_list, notice: 'Word list was successfully updated.' }
        format.json { render :show, status: :ok, location: @word_list }
      else
        format.html { render :edit }
        format.json { render json: @word_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /word_lists/1
  # DELETE /word_lists/1.json
  def destroy
    @word_list.destroy
    respond_to do |format|
      format.html { redirect_to word_lists_url, notice: 'Word list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def deckify
    @user = User.find(params[:user])
    @word_list = WordList.find(params[:word_list])
    @word_list.deckify(@user)
    flash[:sucess] = "Your deck has been created"
    redirect_to user_deck_path(@user, @deck)
  end
  
  def custom_deckify
    @matches = custom_deckify_parse
    @user = User.find(params[:user])
    @word_list = WordList.find(params[:word_list])
    @title = params[:title] || @word_list.title
    @word_list.deckify_with_options(@user, @matches, @title)
    flash[:success] = "Your deck has been created"
    redirect_to user_deck_path(@user, Deck.find_by(title: @title))
  end
    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_word_list
      @word_list = WordList.find(params[:id])
    end
    
    # Check admin status. If user is not an admin, redirect to home page
    def check_admin_status
      if current_user.nil? || !current_user.admin?
        flash[:alert] = "Access denied. Please login as an admin user"
        redirect_to root_url
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def word_list_params
      params.require(:word_list).permit(:title, :course_id,
        :embedded_words_attributes => [:id, :word, :hiragana, :reading, :note, :_destroy,
        :translations_attributes => [:id, :translation, :language, :_destroy]])
    end
    
    def custom_deckify_parse
      output_array = []
      matches_array = Cardifiable::CARDIFIABLE_FIELDS
      outer = matches_array
      inner = matches_array
      outer.each do |outside|
        inner.each do |inside|
          unless params[outside].nil?
            if params[outside][inside] == "1"
              output_array << [outside, inside]
            end
          end
        end
      end
      return output_array
    end
    
end
