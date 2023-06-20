class Transaction < ApplicationRecord
  belongs_to :user
  belongs_to :group, optional: true

  validates :kind, presence: true

  after_commit :update_user_balance, on: :create
  after_save :create_expens_or_income

  include PgSearch::Model

  pg_search_scope :search_by_name_kind_category_amount_frequency,
    against: [:name, :kind, :category, :amount],
    using: {
    tsearch: { prefix: true }
  }

  private

  def create_expens_or_income
    if self.kind == "Expense"
      Expense.create(user: self.user, amount: self.amount, category: self.category, name: self.name, group: self.group)
    else
      Income.create(user: self.user, amount: self.amount, category: self.category, name: self.name)
    end
  end

  def update_user_balance
    amount = self.amount * (kind == "Expense" ? -1:1)
    user.balance += amount
    user.save
  end
end
