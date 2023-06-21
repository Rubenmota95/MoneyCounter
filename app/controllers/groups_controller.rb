class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def show
    @groups = current_user.groups
    @group = Group.find(params[:id])
    @group_expenses= @group.expenses
    if !current_user.groups.exists?(@group.id)
      redirect_to groups_path, notice: "No permission..."
    end
    @expenses = Transaction.where(group: @group, kind: "Expense")
    @settled_group_expenses= @group.transactions.where(group_id: @group.id, kind: "Expense", group_status: true)
    @donut_chart_group = Transaction.where(group_id: @group, kind: "Expense").group(:category).sum(:amount)
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    user_ids = params[:group][:user_ids]
    friends = User.where(id: user_ids)

    friends.each do |friend|
      @group.users << friend
    end

    @group.users << current_user

    if @group.save
      redirect_to groups_path, notice: "Group added successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    user_ids = params[:group][:user_ids]
    friends = User.where(id: user_ids)
    friends.each do |friend|
    @group.users << friend if !@group.users.include?(friend)
    end
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name, user_groups_attributes: [:user_id])
  end

end
