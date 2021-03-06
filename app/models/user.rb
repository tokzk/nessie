class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  validates :username, presence: true,
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 6, maximum: 24 },
                       format: { with: /\A[a-zA-Z\d_\.]+\Z/ }

  attr_accessor :login
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where([
                                "lower(username) = :value OR lower(email) = :value",
                                { value: login.downcase }
                              ]).first
    else
      where(conditions).first
    end
  end
end
