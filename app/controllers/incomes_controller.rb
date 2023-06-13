class IncomesController < ApplicationController

  def index
    @incomes = Income.all
  end

  def show
    @income = Income.find(params[:id])
  end

  def new
    @income = Income.new
  end

  def create
    @income = Income.new(income_params)
    @income.user = current_user
    if @income.save
      redirect_to incomes_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @income = Income.find(params[:id])
  end

  def update
    @income = Income.find(params[:id])
    if @income.update(income_params)
      redirect_to incomes_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @income = Income.find(params[:id])
    @income.destroy
    redirect_to incomes_path
  end

  private

  def income_params
    params.require(:income).permit(:amount, :category, :name, :frequency)
  end
end
