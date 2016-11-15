class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  
  has_and_belongs_to_many :courses
  has_many :categories
  has_many :decks
  has_one :registration
  embeds_one :calendar, autobuild: true
  field :name, type: String
  field :admin?, type: Boolean, default: false
  field :stripe_token, type: String
  field :active_until, type: DateTime
  field :stripe_customer_id, type: String
  field :plan, type: String
  field :active?, type: Boolean, default: false
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  # field :confirmation_token,   type: String
  # field :confirmed_at,         type: Time
  # field :confirmation_sent_at, type: Time
  # field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time
  
  validates :email, uniqueness: true
  validates_presence_of :email, :name
  validates_length_of :name, maximum: 25
  
  
  def word_lists
    if self.courses.any?
      courses = self.courses
      w_lists = []
      courses.each do |course|
        w_lists << course.word_list
      end
      return w_lists
    else
      return nil
    end
  end

  def has_deckified?(word_list)
    user = self
    begin
      deck = Deck.find_by(user: user, from_word_list: "#{word_list.title}")
      self.decks.include?(deck) ? true : false
    rescue
      return nil
    end
  end
  
  protected
  # This method is meant to keep a user's active status up to date
  # and is used in the check_user_active method in application_controller
  # in order to verify whether a user should be allowed to log in or not.
    def update_active
      if self.active_until < Time.now
        self.update_attributes(
          active?: false
          )
      end
    end
  
end
