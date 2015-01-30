class UsersController < ApplicationController
 before_filter :authenticate_user!, :only => [ :edit, :update, :destroy, :show , :order_received, :new_user, :toggled_status]
 before_filter :correct_user, :only => [:toggled_status]

 # helper_method :resource, :resource_name, :devise_mapping

layout :custom_layout
respond_to :html, :xml, :json

def index
 @users = User.all
end

def edit
 @user = User.find(params[:id])
 @users = User.all
end

def new
  @user = User.new
end

def update
  @user = User.find(params[:id])
  if params[:user][:notification_for_email] == "1" || params[:user][:notification_for_personal_email] == "1"
    params[:user].delete(:password) if params[:user][:password].blank?
    params[:user].delete(:password_confirmation) if params[:user][:password_confirmation].blank?
    @user.update_attributes(person_params)
    flash[:notice] = "Profile Updated Successfully "
    redirect_to  edit_user_path(@user)
  else
    flash[:notice] = "Please select atleast one email"
    redirect_to  edit_user_path(@user)
  end
end

def new_user

end

def create_user
  @user = User.new(person_params)
  @user.skip_confirmation!

  if @user.save
    redirect_to root_path,:flash => {:notice => "User successfully created."}
  else
    flash[:notice] = "Email has already been taken "
    render :new_user
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
	@user = User.find(params[:id])
  @user.toggle_status
	redirect_to :back
end

def order_received
  @order_details = Post.joins(:bookings).select('posts.*, bookings.price as total_price').where('bookings.poster_id' => current_user.id)
end


private
  def person_params
    if current_user.admin?
      params.require(:user).permit(:name,:last_name,:personal_email,:mobile_number,:email,:password,:password_confirmation,:admin,:status,:provider,:uid,:mobile_number,:mobile_no,:admin_user_id,:notification,:notification_for_email,:notification_for_personal_email)
    else
      params.require(:user).permit(:name,:last_name,:personal_email,:mobile_number,:email,:password,:password_confirmation, :status,:provider,:uid,:mobile_number,:mobile_no,:admin_user_id,:notification,:notification_for_email,:notification_for_personal_email)
    end
    
  end

  def correct_user
    @user = User.find_by_id_and_admin(current_user.id, true)
    redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
  end


  def custom_layout
    case action_name
      when "new_user"
        "admin"
      else
        "application"
      end
  end

end