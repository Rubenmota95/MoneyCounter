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
        [transaction.created_at.strftime("%b %d"), balance]
      end
    end
  end

  def show
    @transaction = Transaction.find(params[:id])
    if @transaction.user == current_user
      redirect_to transaction_path(transaction)
    else
      redirect_to transactions_path
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
        redirect_to transactions_path

      else
        @group = Group.find(@transaction.group_id)
        redirect_to group_path(@group)
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
    @group = Group.find(params[:group_id])
    create_multiple
    Transaction.where(group: @group, group_status: false).update_all(group_status: true)
    redirect_to group_path(@group)
  end

  def destroy
    @transaction = Transaction.find(params[:id])
    @transaction.destroy
    redirect_to transactions_path
  end

  private

  def create_multiple
    @group.who_to_who.each do |txn|
      txn[:expense].save!
      txn[:income].save!
    end
  end

  def transaction_params
    params.require(:transaction).permit(:amount, :category, :name, :frequency, :group_id, :kind)
  end
end
