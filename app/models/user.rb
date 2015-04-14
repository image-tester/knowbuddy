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

  scope :by_name_email, -> { joins(:posts).where("posts.deleted_at IS NULL").order("name, email").uniq }

  def self.find_gap_boundary(max_duration)
    case max_duration
    when "week" then 7.days.ago
    when "2_weeks" then 14.days.ago
    when "month" then 1.month.ago
    when "quarter" then 3.months.ago
    when "6_months" then 6.months.ago
    when "year" then 1.year.ago
    end
  end

  def self.get_user(user_id)
    self.with_deleted.find(user_id)
  end

  def self.top
    self.joins(:posts).
      select('users.name, users.email, users.id, COUNT(*) as total').
      where('posts.deleted_at IS NULL').
      where('posts.is_draft IS FALSE').
      group('posts.user_id').order('total DESC').limit(5)
  end

  def self.user_collection_email_name
    self.all.map{|v| [v.name || v.email, v.id] } if User.table_exists?
  end

  def self.within_rule_range(rule)
    User.left_join_posts(rule).
      select("users.*, count(p.id) AS p_count").
      group("users.id").
      having("p_count between ? AND ?", (rule["min_count"].to_i), (rule["max_count"].to_i - 1))
  end

  def self.left_join_posts(rule)
    gap_boundary_date = find_gap_boundary(rule["max_duration"])
    posts_after_boundary_date = Post.active_published.
      after_date_boundary(gap_boundary_date.to_s(:db)).to_sql
    joins("LEFT OUTER JOIN ( #{posts_after_boundary_date} ) as p
      ON users.id = p.user_id")
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
