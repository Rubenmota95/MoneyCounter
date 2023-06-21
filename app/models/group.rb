class Group < ApplicationRecord
  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :transactions, through: :users

  # scope :expenses, -> { transactions.where(kind: "Expense", group_status: false)}

  def expenses
    Transaction.where(group: self, kind: "Expense", group_status: false)
  end

  def who_to_who
    debitors = user_amounts_diff.select { |hash| hash[:divided_amount].negative? }
    creditors = user_amounts_diff.select { |hash| hash[:divided_amount].positive? }
    transactions_to_settle = []

    creditors.each_with_index do |creditor, creditor_index|
      debitors.each_with_index do |debitor, debitor_index|

        next if debitor[:amount] == 0

        amount = [debitor[:amount].abs, creditor[:amount]].min

        debitors[debitor_index][:amount] += amount
        creditors[creditor_index][:amount] -= amount

        transactions_to_settle << {
          transaction: Transaction.new(
            amount: amount,
            kind: "Expense",
            group: self,
            category: "Settlement",
            user: debitor[:user],
            group_status: true
          ),
          receiver: creditor[:user],
          payer: debitor[:user],
        }

        break if creditors[creditor_index][:amount] == 0
      end
    end

    transactions_to_settle
  end


  def total
    expenses.sum(:amount)
  end

  def fair_amount
    @fair_amount = total / users.count
  end

  def total_expenses_of(user)
    expenses.where(user: user).sum(:amount)
  end

  def user_amounts_diff
    users.map do |user|
      full_amount = total_expenses_of(user)
      amount = (total_expenses_of(user) - fair_amount)
      {
        user: user,
        amount: amount,
        divided_amount: amount / users.count,
        full_amount: full_amount,
      }
    end
  end




  def user_amounts
    @user_amounts = expenses.group(:user).sum(:amount)
  end

  # def no_expense_users
  #   @no_expense_users = @group.users.select { |user| user.transactions.where(kind: "Expense", group_status: false, group_id: @group).empty? }
  # end

  # def who_to_who
  #   @divided_user_amounts = @user_amounts.transform_values { |value| value / @group.users.count }
  #   @current_user_divided_amount = {}
  #   @current_user_divided_amount = @divided_user_amounts.extract!(current_user.email)
  #   @divided_user_amounts.delete(current_user.email)
  # end

  # def hash
  #   settlement_arr= [
  #     {transaction: Transaction.new(amount: 100 , kind: "Expense", group: self, category: "Settlement", user_id: 1, group_status: true), receiver: user2}
  #   ]

end
