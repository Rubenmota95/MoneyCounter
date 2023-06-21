class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :kind, presence: true

  after_commit :update_user_balance, on: :create

  before_update :remove_transaction_balance
  after_update :updated_user_transaction

  after_destroy :update_user_balance_after_destroy

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

  def remove_transaction_balance
    old_amount = attributes_in_database()[:amount] * (kind == "Income" ? -1:1)
    user.balance += old_amount
    user.save
  end

  def updated_user_transaction
    amount = self.amount * (kind == "Expense" ? -1:1)
    user.balance += amount
    user.save
  end

  def update_user_balance_after_destroy
    amount = self.amount * (self.kind == "Income" ? -1:1)
    user.balance += amount
    user.save
  end
end
