class User < ActiveRecord::Base
  include BCrypt
  attr_reader :entered_password

  has_many :created_events, class_name: "Event" # do I need to add a foreign key here?
  has_many :event_attendances 
  has_many :attended_events, through: :event_attendances, source: :event

  # validates :entered_password #, :length => { :minimum => 6 }
  validates :email, :uniqueness => true, :format => /.+@.+\..+/ # imperfect, but okay


  def password
    @password ||= Password.new(password_hash)
  end

  def password=(pass)
    @entered_password = pass
    @password = Password.create(pass)
    self.password_hash = @password
  end

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    return user if user && (user.password == password)
    nil # either invalid email or wrong password
  end

end

