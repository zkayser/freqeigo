class DecksController < ApplicationController
  before_action :set_deck, only: [:show]
  before_action :find_due, only: [:show]
  
  def index
    @decks = Deck.all
  end

  def show
    if @deck.cards.due.to_a
      @facts = @deck.cards.due.to_a
      @first = @facts.sample
    else
      @message = "No cards due at this time."
    end
  end

  def new
    @deck = Deck.new
  end

  def create
    @deck = Deck.new(deck_params)
    
    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck }
        format.json { render :show, status: :created, location: @deck }
      else
        format.html { render :new }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @deck = Deck.find(params[:id])
  end

  def update
  end

  def destroy
    @deck = Deck.find(params[:id])
    if @deck.destroy
      flash[:now] = "Deck destroyed"
    end
    redirect_to user_decks_path(current_user)
  end
  
  # This action should really be split up into a couple different
  # actions, but they are just being thrown together now for
  # the sake of convenience.
  def multi_delete
    @deck = Deck.find(params[:deck])
     @card_params = params[:card_ids]
     @cards = []
    if params[:commit] == "Delete"
      @card_params.each do |id|
        card = @deck.cards.find(id)
        @cards << card
      end
      @delete = @cards
      @cards.each do |card|
        card.destroy
      end
      respond_to do |format|
        format.js { render 'decks/multi_delete' } and return
      end
    elsif params[:commit] == "Update"
      @deck.cards.each do |card|
        card.next_due = Time.now
        card.save!
      end
      @deck.save!
      flash[:success] = "Set all cards next review date to now."
      flash.keep(:success)
      render js: "window.location = '#{user_decks_path(current_user)}'"
    end
  end
  
  def new_card
    @deck = Deck.find(params[:deck])
    @user = current_user
    @card = Card.new
  end
  
  def edit_card
    @deck = Deck.find(params[:deck])
    @card = @deck.cards.find(params[:card])
    @user = current_user
    @params = params
  end
  
  private
  
    # White list params
    def deck_params
      params.require(:deck).permit(:title)
    end
    
    # Set up the deck to display
    def set_deck
      @deck = Deck.find(params[:id])
      @deck.reset_current_stats
    end
  
    # Before processing any action, make sure to find the cards
    # that are due.
    def find_due
      @deck.cards.each do |card|
        card.check_due
      end
    end
end
