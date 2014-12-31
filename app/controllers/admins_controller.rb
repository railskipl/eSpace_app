class AdminsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :correct_user, :only => [:index, :show, :destroy]
  layout :custom_layout

  def index
    unless params[:format].present?
      @adminusers = User.admin_search.page(params[:page]).per_page(50)
    else
      @adminusers = User.admin_search
    end
    respond_to do |format|
      format.html
      format.xls
      format.pdf do
        render :pdf => "users_report"
      end
    end
	end

  def show
    @user = User.find(params[:id])
  end

  def destroy
     @user = User.find(params[:id])
     @user.delete

     redirect_to admins_path
  end


  private
    def correct_user
      @user = User.find_by_id_and_admin(current_user.id, true)
       redirect_to(root_path, :notice => "Sorry, you are not allowed to access that page.") unless current_user=(@user)
     end


     def custom_layout
        case action_name
         when "index"
          "admin"
        when "show"
          "admin"
         else
          "application"
       end
      end



end
