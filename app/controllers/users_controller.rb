class UsersController < ApplicationController
	# sbefore_filter :authenticate_user!, :only => [ :show]
 # helper_method :resource, :resource_name, :devise_mapping
 #respond_to :html, :js, :json

def index
 @users = User.all
end

def edit
	
 @user = User.find(params[:id])
end
 
def new

  @user = User.new	
end

def update
# raise "hi"
  @user = User.find(params[:id])
  params[:user].delete(:password) if params[:user][:password].blank?
  params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
  @user.update_column(:name,"#{params[:user][:name]}")
  @user.update_column(:last_name,"#{params[:user][:last_name]}")
  @user.update_column(:personal_email,"#{params[:user][:personal_email]}")
  @user.update_column(:mobile_number,"#{params[:user][:mobile_number]}")
  flash[:notice] = "Profile Updated Successfully "
  redirect_to root_path


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

private

	
def person_params
  params.require(:user).permit(:name, :last_name,:personal_email,:mobile_number)
end

end