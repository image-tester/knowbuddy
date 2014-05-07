class User < ActiveRecord::Base
  include PublicActivity::Common

  attr_accessible :email, :name, :password, :password_confirmation,
    :remember_me
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :comments
  has_many :posts

  validates_presence_of :name

  acts_as_paranoid

  after_create :send_welcome_email
  after_update :send_email_password_changed, if: :encrypted_password_changed?

  after_create :create_user_activity

  def self.user_collection_email_name
    self.all.map{|v| [v.name || v.email, v.id] } if User.table_exists?
  end

  def self.top3
    self.with_deleted.joins(:posts).
      select('users.name, users.email, users.id, COUNT(*) as total').
      where('posts.deleted_at IS NULL').
      group('posts.user_id').order('total DESC').limit(3)
  end

  def self.get_user(user_id)
    self.with_deleted.find(user_id)
  end

  def activate
    if valid?
      recover
    else
      self.deleted_at = nil
      save(validate: false)
    end
  end

  def display_name
    name.try(:titleize) || email
  end

  def self.by_name_email
    with_deleted.joins(:posts).where('posts.deleted_at IS NULL').
    order('name, email').uniq
  end

  def activity_params
    { "user" => name }
  end

  def active?
    deleted_at.blank?
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
      Activity.add_activity('create',self)
    end
end