class User < ApplicationRecord
  has_many :goals, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups


  has_one_attached :photo

  validates :username, presence: true, uniqueness: true


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  private

  def validate_username_uniqueness
    if username_changed? && User.exists?(username: username)
      errors.add(:username, 'has already been taken')
    end
  end
end
