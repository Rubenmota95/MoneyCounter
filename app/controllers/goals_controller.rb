class GoalsController < ApplicationController

  def index
    @goals = Goal.all.order(created_at: :asc)
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user
    if @goal.save
      redirect_to goals_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @goal = Goal.find(params[:id])
  end

  def update
    @goal = Goal.find(params[:id])
    if @goal.update(goal_params)
      redirect_to goals_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @goal = Goal.find(params[:id])
    @goal.destroy
    redirect_to goals_path
  end

  # PATCH /goals/:id/favorite
  def favorite
    @goal = Goal.find(params[:id])
    current_user.goals.each do |goal|
      goal.favorite = false
      goal.save
    end
    @goal.update(favorite: true)
    redirect_to goals_path
  end

  private

  def goal_params
    params.require(:goal).permit(:name, :amount, :category, :url)
  end
end
