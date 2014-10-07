class UsersController < ApplicationController
	before_filter :authenticate_user!, :only => [ :show]

def dashboard

  end

def edit
@user = User.find(params[:id])
end

def update
@user = User.find(params[:id])
end

 def destroy
@user = User.find(params[:id])
@user.destroy
flash[:notice] = "User deleted successfully."
redirect_to root_path
end
 def show
@user = User.find(params[:id])

end

def toggled_status
@users = User.find(params[:id])
@users.status = !@users.status?
@users.update_column(:status,@users.status)
redirect_to :back
# UserMailer.user_status_mail(@users).deliver
end
end