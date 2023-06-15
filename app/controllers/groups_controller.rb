class GroupsController < ApplicationController
  def index
    @groups = current_user.groups
  end

  def show
    @group = Group.find(params[:id])
    if @group.user == current_user
      redirect_to group_path(group)
    else
      redirect_to groups_path, notice: "No permission..."
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    # friend = User.find(params[:group][:users].to_i)
    # @group_users << friend
    @group.users << current_user
    raise
    if @group.save
      redirect_to groups_path, notice: "group added successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
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
    params.require(:group).permit(:name)
  end

end
