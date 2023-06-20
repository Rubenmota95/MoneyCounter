class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :kind, presence: true

  after_commit :update_user_balance, on: :create

  include PgSearch::Model

  pg_search_scope :search_by_name_kind_category_amount_frequency,
    against: [:name, :kind, :category, :amount],
    using: {
    tsearch: { prefix: true }
  }

  private

  def update_user_balance
    amount = self.amount * (kind == "Expense" ? -1:1)
    user.balance += amount
    user.save
  end
end
