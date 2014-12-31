class User < ActiveRecord::Base
  include PublicActivity::Common

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  has_many :comments
  has_many :posts

  validates :name, presence: true

  acts_as_paranoid
  acts_as_voter

  after_create :send_welcome_email
  after_update :send_email_password_changed, if: :encrypted_password_changed?

  after_create :create_user_activity

  scope :by_name_email, -> { joins(:posts).where('posts.deleted_at IS NULL').order('name, email').uniq }


  def self.get_user(user_id)
    self.with_deleted.find(user_id)
  end

  def self.top3
    self.with_deleted.joins(:posts).
      select('users.name, users.email, users.id, COUNT(*) as total').
      where('posts.deleted_at IS NULL').
      where('posts.is_draft IS FALSE').
      group('posts.user_id').order('total DESC').limit(3)
  end

  def self.user_collection_email_name
    self.all.map{|v| [v.name || v.email, v.id] } if User.table_exists?
  end

  def activate
    if valid?
      restore
    else
      self.deleted_at = nil
      save(validate: false)
    end
  end

  def activity_params
    { user: name }
  end

  def active?
    deleted_at.blank?
  end

  def display_name
    name.try(:titleize) || email
  end

  def is_voted?(post, type)
    self.send("voted_#{type}_on?", post)
  end

  private
  def send_email_password_changed
    Resque.enqueue(PasswordNotification,self)
  end

  def send_welcome_email
    Resque.enqueue(WelcomeNotification,self)
  end

  def create_user_activity
    Activity.add_activity("create", self)
  end
end
