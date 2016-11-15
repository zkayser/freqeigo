class UsersController < ApplicationController
  before_action :update_current_correct, only: [:deck_show], unless: "cookies[:sandbox_review]"
  before_action :check_due, only: [:deck_show]
  
  
  def index
    @users = User.all.to_a
    @users_with_stripe = []
    @users.each do |user|
      if user.stripe_customer_id 
        @users_with_stripe << user
      end
    end
  end
  
  def show
    @decks = current_user.decks
  end

  def edit
  end
  
  def new_deck
    @user = current_user
    @deck = Deck.new(user: @user)
  end
  
  def create_new_deck
    @user = current_user
    @category = Category.find(params[:deck][:category])
    @subcategory = Subcategory.find(params[:deck][:subcategory])
    @title = params[:deck][:title]
    @deck = Deck.new(title: @title, user: @user, category: @category, subcategory: @subcategory)
    @user.decks << @deck
    if @deck.save! && @user.save!
      respond_to do |format|
        format.html { redirect_to user_decks_path(@user), notice: 'Deck created successfully' }
      end
    else
      redirect_to :back
    end
  end
  
  def user_deck_create
    @user = current_user
    @title = params[:title]
    @deck = @user.decks.new(title: @title)
    @fact_hash = {}
    params.each do |k, v|
      if k.match(/fact_\d/)
        @fact_hash[k] = v
      end
    end
    @facts = @fact_hash.values
    @facts.each do |fact|
      word = Word.find_by(word: fact)
      word.cardify(@deck)
    end
    flash[:success] = "Deck created. Good luck studying!"
    redirect_to user_deck_path(@deck)
  end
  
  def deck_index
    @user = current_user
    @decks = current_user.decks.all.page params[:page]
    @decks.each do |deck|
      deck.cards.each do |card|
        card.check_due
      end
    end
    render :action => 'deck_index'
  end
  
  def deck_show
    sandbox = params[:sandbox_review]
    @deck = Deck.find(params[:deck])
    @deck.sandbox_passed.clear
    @deck.save
    unless sandbox
      cookies.delete(:sandbox_review)
      if @deck.cards.due.to_a
        @facts = @deck.cards.due.to_a
        @first = @facts.sample
      else
        @message = "No cards due at this time."
      end
    else
      cookies[:sandbox_review] = { value: sandbox, expires_in: 1.hour.from_now }
      @facts = @deck.cards.all.to_a
      @first = @facts.sample
    end
    render :action => 'deck_show'
  end
  
  def admin_panel
    render 'admin/admin_panel'
  end
  
  private
  # Remembers the number of questions answered correctly on a deck
  # for one day --> Probably should move this into a helper module
  # at some point
  # The time implementation here is completely arbitray. I am just going off
  # gut feeling.
  def update_current_correct
    @deck = Deck.find(params[:deck])
    @deck.reset_current_stats
  end
  
  # Before filter to update the cards that are due
  def check_due
    @deck = Deck.find(params[:deck])
    @deck.cards.each do |card|
      card.check_due
    end
  end

end
