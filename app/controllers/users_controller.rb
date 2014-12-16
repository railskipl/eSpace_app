class UsersController < ApplicationController
 before_filter :authenticate_user!, :only => [ :edit, :order_received, :new_user, :toggled_status]
 before_filter :correct_user, :only => [:new_user, :toggled_status]

 # helper_method :resource, :resource_name, :devise_mapping
 #respond_to :html, :js, :json
# before_filter :authenticate_user!
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
  @user.update_column(:notification,"#{params[:user][:notification]}")
  @user.update_column(:notification_for_email,"#{params[:user][:notification_for_email]}")
  @user.update_column(:notification_for_personal_email,"#{params[:user][:notification_for_personal_email]}")
  
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
	@users = User.find(params[:id])
	@users.status = !@users.status?
	@users.update_column(:status,@users.status)
	redirect_to :back
	# UserMailer.user_status_mail(@users).deliver
end

def order_received
  @order_details = Post.joins(:bookings).select('posts.*, bookings.price as total_price').where('bookings.poster_id' => current_user.id)

end



  private

  	
    def person_params
      params.require(:user).permit(:name,:last_name,:personal_email,:mobile_number,:email,:password,:password_confirmation,:admin,:status,:provider,:uid,:mobile_number,:mobile_no,:admin_user_id,:notification,:notification_for_email,:notification_for_personal_email)
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