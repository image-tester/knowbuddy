class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :kyu_entries
  has_many :comments
  after_create :send_welcome_email 
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  
  private
  
      #Added by Rohan. Functionality - Send email notification to user upon new account signup
      def send_welcome_email
        UserMailer.welcome_email(self).deliver 
      end
end
