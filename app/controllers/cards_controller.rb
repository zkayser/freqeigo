class CardsController < ApplicationController
  before_action :set_card, only: [:successful_review, :unsuccessful_review]
  
  def new
    @card = Card.new
  end
  
  def create
    @user = current_user
    @deck = Deck.find_by(id: params[:card][:deck])
    @card = Card.new(top: params[:card][:top], bottom: params[:card][:bottom], question_type: params[:card][:question_type])
    @card.deck = @deck
    
    
    respond_to do |format|
      if @card.save
        format.html { redirect_to new_deck_card_path(@deck), notice: "Card Successfully created" }
      else
        format.html { redirect_to new_deck_card_path }
      end
    end
  end
  
  def update
    @user = current_user
    @deck = Deck.find(params[:card][:deck])
    @card = @deck.cards.find(params[:card][:card])
    @card.update_attributes(
      top: params[:card][:top],
      bottom: params[:card][:bottom],
      question_type: params[:card][:question_type]
      )
    
    respond_to do |format|
      if @card.save
        format.html { redirect_to user_deck_path(@user, @deck), message: "Card successfully updated" }
      else
        format.html { redirect_to edit_deck_card_path(@card) }
      end
    end
  end
  
  def destroy # Make remote ajax call
    @card = Card.find(params[:card])
    @card.destroy
    flash[:now] = "Card destroyed"
  end
    

  def successful_review
    @deck = Deck.find(params[:deck_id])
    unless cookies[:sandbox_review]
      @card.succeed(@deck)
      @due = @deck.current_due
      @due.delete(@card)
      @fact = @due.sample
    else
      @card.succeed_in_sandbox_mode(@deck)
      @cards = @deck.cards.all.to_a
      @due = []
      @cards.each do |card|
        @due << card unless card.id.in?(@deck.sandbox_passed)
      end
      @fact = @due.sample 
    end
    respond_to do |format|
      format.js { render "decks/successful_review" }
    end
  end
  
  def unsuccessful_review
    @deck = Deck.find(params[:deck_id])
    unless cookies[:sandbox_review]
      @card.failed(@deck)
      @due = @deck.cards.due
      @fact = set_fact(@card, @deck)
    else
      @card.failed_in_sandbox_mode(@deck)
      @cards = @deck.cards.all.to_a
      @due = []
      @cards.each do |card|
        @due << card unless card.id.in?(@deck.sandbox_passed)
      end
      @fact = @due.sample
    end
    respond_to do |format|
      format.js { render "decks/unsuccessful_review" }
    end
  end
  
  private
  
  def card_params
    params.require(:card).permit(:top, :bottom, :deck, :deck_id, :question_type)
  end
  
  # Before action
  def set_card
    @card = Deck.find(params[:deck_id]).cards.find(params[:id])
  end
  
  def set_fact(card, deck)
    due = deck.current_due
    sample = due.sample
    unless due.length == 1
      unless sample == card
        until sample != card do
          due.sample
        end
      else
      fact = sample
      end
      fact = sample
    end
    return fact
  end
end