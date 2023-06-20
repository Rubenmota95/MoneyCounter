class GoalsController < ApplicationController

  def index

    @goals = Goal.all.order(created_at: :asc).where(user: current_user)
    if params[:query].present?
      @goals = Goal.search_by_name_category_amount_frequency(params[:query])
    else
      @goals = Goal.all
    end
    @favorite_array = []
    @goals.each do |goal|
      @favorite_array << goal if goal.favorite == true
    end

    if !@goals.empty?
      if @favorite_array.empty?
        @percentage = ((current_user.balance * 100) / @goals.first.amount).round()
        if @percentage > 100
          @percentage = 100
        elsif @percentage < 0
          @percentage = 0
        end
      else
        @percentage = ((current_user.balance * 100) / @favorite_array.first.amount).round()
        if @percentage > 100
          @percentage = 100
        elsif @percentage < 0
          @percentage = 0
        end
      end
    end
  end

  def show
    @goal = Goal.find(params[:id])
    if @goal.user == current_user
      redirect_to goal_path(goal)
    else
      redirect_to goals_path, notice: "No permission..."
    end
  end

  def new
    @goal = Goal.new
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.user = current_user
    if @goal.save
      redirect_to goals_path, notice: "Goal added successfully"
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
    params.require(:goal).permit(:name, :amount, :category, :url, :photo)
  end
end
