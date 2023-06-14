class ExpensesController < ApplicationController

  def index
    @expenses = Expense.where(user: current_user)
  end

  def show
    @expense = Expense.find(params[:id])
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    @expense.user = current_user
    if @expense.save
      redirect_to expenses_path
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
    params.require(:expense).permit(:amount, :category, :name, :frequency)
  end
end
