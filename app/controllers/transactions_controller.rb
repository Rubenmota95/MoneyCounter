class TransactionsController < ApplicationController

  def index
    @transactions = Transaction.where(user: current_user, group_id: nil)
    if params[:query].present?
      @transactions = Transaction.search_by_name_kind_category_amount_frequency(params[:query])
      if params[:query] == "expense" || params[:query] == "income"
        @donut_chart_data = Transaction.where(user: current_user, group_id: nil, kind: params[:query].capitalize).group(:category).sum(:amount)
      end
    else
      @transactions = Transaction.where(user: current_user).order(:created_at)
      balance = 0
      @area_chart_data = @transactions.map do |transaction|
        balance += (transaction.kind == 'Expense' ? -1 : 1) * transaction.amount
        [@transactions.index(transaction), balance]
      end
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
    if @transaction.user == current_user
      redirect_to transaction_path(transaction)
    else
      redirect_to transactions_path, notice: "No permission..."
    end
  end

  def new
    @transaction = Transaction.new
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.user = current_user
    if @transaction.save!
      if @transaction.group_id.nil?
        redirect_to transactions_path, notice: "Transaction added successfully"

      else
        @group = Group.find(@transaction.group_id)
        redirect_to group_path(@group), notice: "Transaction added successfully to #{@group.name}"
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @transaction = Transaction.find(params[:id])
  end

  def update
    @transaction = Transaction.find(params[:id])
    if @transaction.update(transaction_params)
      redirect_to transactions_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def update_group_status
    group_id = params[:group_id]
    Transaction.where(group_id: group_id, group_status: false).update_all(group_status: true)
    redirect_to group_path(group_id), notice: "Group status updated successfully."
  end

  def settle_events
    group = Group.find(params[:group_id])

    Transaction.new(name: "#{group.name} from #{user.email}" , amount: , kind: "Income", group: group, category: "Settlement", user_id: )
    Transaction.new(name: "#{group.name} to #{user.email}" , amount: , kind: "Expense", category: "Settlement", user_id: )
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to transactions_path
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :category, :name, :frequency, :group_id, :kind)
  end
end
