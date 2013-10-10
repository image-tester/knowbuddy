class User < ActiveRecord::Base
  include PublicActivity::Common
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable,
  # :timeoutable and :omniauthable
  attr_accessible :email, :name, :password, :password_confirmation,
                  :remember_me
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable
  has_many :comments
  has_many :kyu_entries

  validates_presence_of :name

  acts_as_paranoid

  scope :by_name_email, order: 'name, email'
  scope :get_user, lambda { |user_id|
    where('id = ?', user_id)
  }
  scope :top3, lambda{ joins(:kyu_entries).
               select('users.name, users.email, users.id, COUNT(*) as total').
                       where('kyu_entries.deleted_at IS NULL').
                       group('kyu_entries.user_id').order('total DESC').
                       limit(3)}

  after_create :send_welcome_email
  after_update :send_email_password_changed, if: :encrypted_password_changed?

  after_create :create_user_activity

  # Setup accessible (or protected) attributes for your model

  def self.user_collection_email_name
    self.all.map{|v| [v.name || v.email, v.id] }
  end
  private
    #Added by Rohan.
    #Functionality - Send email notification to user upon new account signup
    def send_email_password_changed
      Resque.enqueue(PasswordNotification,self)
    end

    def send_welcome_email
      Resque.enqueue(WelcomeNotification,self)
    end

    def create_user_activity
      act_type = ActivityType.find_by_activity_type('user.create')
      (self.create_activity :create, params: {"1"=> self.name})
          .tap{|a| a.owner_id = self.id; a.owner_type = 'User';
           a.activity_type_id = act_type.id; a.save}
    end
end