class GroupsController < ApplicationController
	before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
	def index
		@groups= Group.all
	end
	def new
		@group= Group.new
	end
	def show
		@group= Group.find(params[:id])
		@posts= @group.posts
	end
	def create
		@group= Group.create(group_params)
		if @group.save
			current_user.join!(@group)
			redirect_to groups_path
		else
			render :new
		end
	end
	def group_params
		params.require(:group).permit(:title, :description)
	end
	def edit
		@group= Group.find(params[:id])
	end
	def update
		@group= Group.find(params[:id])

		if @group.update(group_params)
			redirect_to groups_path , notice:"Edit successfully"
		else
			render :edit
		end
	end
	def destroy
		@group= Group.find(params[:id])
		@group.destroy
		redirect_to groups_path, alert: "Delete successfully"
	end
	def join
		@group = Group.find(params[:id])

		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
			flash[:notice] = "join the group successfully"
		else
			flash[:warning] = "You are one of the group"
		end
		redirect_to groups_path(@group)
	end
	def quit
		@group = Group.find(params[:id])

		if  current_user.is_member_of?(@group)
			current_user.quit!(@group)
			flash[:alert] = "leave the group successfully"
		else
			flash[:warning] = "You are not one of the member"
		end
		redirect_to groups_path(@group)
	end
end
