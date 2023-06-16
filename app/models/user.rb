class User < ApplicationRecord
  has_many :goals
  has_many :expenses
  has_many :incomes
  has_many :user_groups, dependent: :destroy
  has_many :groups, through: :user_groups

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
