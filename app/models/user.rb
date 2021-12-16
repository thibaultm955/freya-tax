class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one :assignment
  has_many :user_access_companies
  has_one :company, through: :assignment
  belongs_to  :language

  def self.user_connected?(current_user)

    if current_user.nil?

      redirect_to root_path

    else
      return true
    end
  end
end
