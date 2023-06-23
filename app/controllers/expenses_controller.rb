class ExpensesController < ApplicationController

  def index
    @expenses = Expense.where(user: current_user,group_id: nil)
  end

  def show
    @expense = Expense.find(params[:id])
    if @expense.user == current_user
      redirect_to expense_path(expense)
    else
      redirect_to expenses_path
    end
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user

    if @expense.save!
      if @expense.group_id.nil?
        redirect_to expenses_path
      else
        @group = Group.find(@expense.group_id)
        redirect_to group_path(@group)
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @expense = Expense.find(params[:id])
  end

  def update
    @expense = Expense.find(params[:id])
    if @expense.update(expense_params)
      redirect_to expenses_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense = Expense.find(params[:id])
    @expense.destroy
    redirect_to expenses_path
  end

  private

  def expense_params
    params.require(:expense).permit(:amount, :category, :name, :frequency, :group_id)
  end
end
