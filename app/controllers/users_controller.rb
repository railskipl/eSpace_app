class UsersController < ApplicationController
	# sbefore_filter :authenticate_user!, :only => [ :show]
 # helper_method :resource, :resource_name, :devise_mapping
 #respond_to :html, :js, :json
# before_filter :authenticate_user!
  respond_to :html, :xml, :json
def index
 @users = User.all
end

def edit
 @user = User.find(params[:id])
end
 
def new
  @user = User.new	
end
 # def create
 #   @user = User.new(params[:id])
 #    @user.save
 #   if @user.save
 #    redirect_to root_path,:flash => {:notice => "User successfully created."}  
 #    end
 # end
def update
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


 def new_user
    @user = User.new
 end

 def create_user
  
   @user = User.new(person_params)
   @user.skip_confirmation!

   if @user.save
    redirect_to root_path,:flash => {:notice => "User successfully created."}  
   end
 
 end



def confirm
   	@user = User.find_for_facebook_oauth(request.env["omniauth.auth"])
   end

def destroy
	@user = User.find(params[:id])
	@user.delete
	flash[:notice] = "User deleted successfully."
	redirect_to root_path
end

 def show
	@user = User.find(params[:id])
	@users=User.where("id =?",@user.id)
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
  params.require(:user).permit(:name,:last_name,:personal_email,:mobile_number,:email,:password,:password_confirmation,:admin,:status,:provider,:uid,:mobile_number,:mobile_no,:admin_user_id)
end

end