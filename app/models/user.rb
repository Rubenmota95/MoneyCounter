class User < ApplicationRecord
  has_many :goals
  has_many :expenses
  has_many :incomes
  has_one_attached :photo
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  validates :username, presence: true, uniqueness: true


  private

  def validate_username_uniqueness
    if username_changed? && User.exists?(username: username)
      errors.add(:username, 'has already been taken')
    end
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable



end
