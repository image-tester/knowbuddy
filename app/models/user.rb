class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable

  acts_as_paranoid

  has_many :kyu_entries
  has_many :comments
  after_create :send_welcome_email

  validates_presence_of :name

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation,
                  :remember_me, :name

  scope :top3, lambda{ joins(:kyu_entries).
                       select('users.name, users.email, users.id, COUNT(*) as total').
                       where('kyu_entries.deleted_at IS NULL').
                       group('kyu_entries.user_id').order('total DESC').
                       limit(3)}

  def self.user_collection_email_name
    self.all.map{|v| [v.name || v.email, v.id] }
  end

  private

    #Added by Rohan.
    #Functionality - Send email notification to user upon new account signup
    def send_welcome_email
      Resque.enqueue(WelcomeNotification,self)
    end
end

